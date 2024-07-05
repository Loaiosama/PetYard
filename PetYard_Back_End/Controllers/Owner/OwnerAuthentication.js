const pool = require('../../db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const Model = require('./../../Models/UserModel');
const sendemail = require("./../../Utils/email");
const axios = require('axios');
const saltRounds = 10;
const multer =require('multer');
const sharp = require('sharp');




const multerStorage=multer.memoryStorage();

const multerFilter=(req,file,cb)=>{
    if(file.mimetype.startsWith('image')){
        cb(null,true);
    }
    else{
        cb("Not an image! please upload only images.",false)
    }
}


const upload=multer({

    storage:multerStorage,
    fileFilter:multerFilter
});

const uploadphoto=upload.single('Image');

const resizePhoto=(req,res,next)=>{

    if(!req.file) return next();

    req.file.filename=`petowner-${req.ID}-${Date.now()}.jpeg`;

    sharp(req.file.buffer).resize(500,500).toFormat('jpeg').jpeg({quality:90}).toFile(`public/img/users/PetOwner/${req.file.filename}`);
    next();
}

const signUp = async (req, res) => {
    const { firstName, lastName, pass, email, phoneNumber, dateOfBirth } = req.body;
    let Image = req.file ? req.file.filename : 'default.png';

    try {
        if (!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        // Phone number validation
        const phoneRegex = /^\d+$/;
        if (!phoneRegex.test(phoneNumber)) {
            return res.status(400).json({
                status: "Fail",
                message: "Phone number must consist of only digits"
            });
        }

        // Age validation
        const birthDate = new Date(dateOfBirth);
        const today = new Date();
        const age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        const dayDiff = today.getDate() - birthDate.getDate();
        if (age < 16 || (age === 16 && (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)))) {
            return res.status(400).json({
                status: "Fail",
                message: "User must be at least 16 years old"
            });
        }

        const client = await pool.connect();

        // Check if email or phone number already exist in the Petowner table
        const emailExistsQuery = 'SELECT * FROM Petowner WHERE Email = $1';
        const phoneExistsQuery = 'SELECT * FROM Petowner WHERE Phone = $1';
        const emailExistsResult = await client.query(emailExistsQuery, [email]);
        const phoneExistsResult = await client.query(phoneExistsQuery, [phoneNumber]);

        if (emailExistsResult.rows.length > 0) {
            console.log("Email already exists in Petowner table");
            return res.status(400).json({ message: "Email already exists, try another email." });
        }

        if (phoneExistsResult.rows.length > 0) {
            console.log("Phone number already exists in Petowner table");
            return res.status(400).json({ message: "Phone number already exists, try another phone number." });
        }

        // Check if email or phone number already exist in the temporary table
        const emailExistsTempQuery = 'SELECT * FROM Temp_Petowner WHERE Email = $1';
        const phoneExistsTempQuery = 'SELECT * FROM Temp_Petowner WHERE Phone = $1';
        const resultEmail = await client.query(emailExistsTempQuery, [email]);
        const resultPhone = await client.query(phoneExistsTempQuery, [phoneNumber]);

        if (resultEmail.rows.length === 1 && resultPhone.rows.length === 1) {
            console.log("User already exists in temporary table");
            return res.status(400).json({ message: "User already exists in temporary table, try another Email and Phone number." });
        } else if (resultPhone.rows.length === 1) {
            console.log("User already exists in temporary table");
            return res.status(400).json({ message: "User already exists in temporary table, try another Phone number." });
        } else if (resultEmail.rows.length === 1) {
            console.log("User already exists in temporary table");
            return res.status(400).json({ message: "User already exists in temporary table, try another Email." });
        }

        const hashedPassword = await bcrypt.hash(pass, saltRounds);
        const { validationCode } = Model.CreateValidationCode();

        const insertQuery = `
            INSERT INTO Temp_Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth, Image, ValidationCode)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            RETURNING *
        `;
        const newUser = await client.query(insertQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth, Image, validationCode]);

        const message = `Your Validation code ${validationCode} \n Insert the Validation code to enjoy with Our Services`;

        await sendemail.sendemail({
            email: email,
            subject: 'Your Validation code (valid for 10 min)',
            message
        });

        res.status(201).json({
            message: "Sign up successful, check your email for validation code"
        });

        client.release();
    } catch (e) {
        console.error("Error during signUp", e);
        res.status(500).json({ error: "Internal server error" });
    }
}

const validateCodeAndTransfer = async (req, res) => {
    const { email, validationCode } = req.body;

    try {
        const client = await pool.connect();

        // Check if the validation code matches and is still valid
        const checkValidationCode = `
            SELECT * FROM Temp_Petowner
            WHERE Email = $1 AND ValidationCode = $2 AND ValidationCodeExpires > NOW()
        `;
        const result = await client.query(checkValidationCode, [email, validationCode]);

        if (result.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Validation code is invalid or has expired"
            });
        }

        // If validation is successful, move data to Petowner table
        const userData = result.rows[0];
        const insertQuery = `
            INSERT INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth, Image)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
        `;
        await client.query(insertQuery, [
            userData.first_name,
            userData.last_name,
            userData.password,
            userData.email,
            userData.phone,
            userData.date_of_birth,
            userData.image
        ]);

        // Delete the temporary record
        const deleteQuery = `
            DELETE FROM Temp_Petowner
            WHERE Email = $1
        `;
        await client.query(deleteQuery, [email]);

        client.release();

        res.status(200).json({
            status: "Success",
            message: "Account verified and transferred to Petowner table successfully"
        });

    } catch (error) {
        console.error("Error during validation and transfer:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}



const signIn = async (req, res) => {
    const { email, password } = req.body;
    try {
        // Check if both email and password are provided
        if (!email || !password) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide email and password"
            });
        }

        // Query the database for the user with the provided email and password
        const result = await pool.query('SELECT * FROM Petowner WHERE email = $1', [email]);

        // If user not found
        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email or password"
            });
        }

        // Check if the password matches
        const user = result.rows[0];
        const isPasswordMatch = await bcrypt.compare(password, user.password);


        if (!isPasswordMatch) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email or password"
            });
        }
        
        // Extract the owner ID from the query result
        const ownerId = user.owner_id;
        // Generate a JWT token based on the owner ID
        const token = jwt.sign({ ID: ownerId }, 'your_secret_key', { expiresIn: '24h' });

        // Send the token back to the client
        res.status(200).json({
            status: "Success",
            token
        });

    } catch (error) {
        console.error("Error signing in:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
const deleteAccount = async (req, res) => {

    const owner_id = req.ID;

    try {

        const Query = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const result = await pool.query( Query, [owner_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist"
            });
        }

        const deleteQuery = 'DELETE FROM Petowner WHERE Owner_Id = $1';
        await pool.query(deleteQuery, [owner_id]);

        res.status(200).json({
            status: "Success",
            message: "Account deleted successfully"
        });

    }
    catch (error) {
        console.error("Error deleting account:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
}

}

const forgotPassword = async (req, res) => {
    const { email } = req.body;

    try {
        if (!email) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill Your Email"
            });
        }

        const result = await pool.query('SELECT * FROM Petowner WHERE email = $1', [email]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email"
            });
        }

        const { resetToken,PasswordResetToken} = Model.CreatePasswordResetToken();

       await pool.query('UPDATE Petowner SET ResetToken = $1 WHERE email = $2', [PasswordResetToken, email]);

        const resetURL = `${req.protocol}://${req.get('host')}/PetOwner/Resetpassword/${resetToken}`;

        const message = `Forgot Your password? Submit A put request with your new password to: ${resetURL}.\n If you didnt forget your password, please ignore this email!`;

        await sendemail.sendemail({
            email: email,
            subject: 'Your password reset token (valid for 10 min) ',
            message
        });

        res.status(200).json({
            status: 'success',
            message: 'Token sent to email!'
        });

    } catch (error) {

        console.error("Error sending email:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });

    }
}


const resetPassword = async (req,res)=>{

    const { token } = req.params;
    const { pass, email } = req.body;   
    const hashedToken1 = crypto.createHash('sha256').update(token).digest('hex'); 
    const {PasswordResetExpires} = Model.CreatePasswordResetToken();
   try {
   
    if(!pass || !email)
    {
        return res.status(400).json({
            status: "Fail",
            message: "Please Fill All Information"
        });

    }
        const result = await pool.query('SELECT * FROM Petowner WHERE email = $1', [email]);
        const hashedToken2 = result.rows[0].resettoken;
        ;
      
        
        if (!hashedToken2) {
            return res.status(400).json({
                status: "Fail",
                message: "No password reset token found for this email"
            });
        }
                
    if ( !hashedToken2 || hashedToken2 !== hashedToken1 || PasswordResetExpires < Date.now()) {
        return res.status(400).json({
            status: "Fail",
            message: "Token is invalid or has expired"
        });
    }
    const hashedPassword = await bcrypt.hash(pass, saltRounds);
    const newpass = 'UPDATE Petowner SET Password = $1 , ResetToken = NULL WHERE Email = $2';
    await pool.query(newpass, [hashedPassword, email]);  
    res.status(200).json({ message: "Password Changed correctly" });
    
   } catch (error) {

    res.status(500).json({ error: "Internal server error" });
   }
}


const validationCode = async (req,res)=> 
{
    const valid=req.params;
    

    const {VaildationcodeExpires } = Model.CreateValidationCode();
    const {code}=req.body;

    if (VaildationcodeExpires >= Date.now() && code === valid.ValidCode)
    {
        
        if(!code)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide Validation Code"
            });
        }

        res.status(200).json({ message: "Validation Code correctly" });
    }

    else{

       return res.status(400).json({
        status : "Fail",
        Message : "Validition Code is invalid or has expired "
       });
    }
    
}

const updateInfo = async (req, res) => {

    const owner_id = req.ID;
    const {firstName, lastName, pass, email, phoneNumber,dateOfBirth } = req.body;
    let Image = req.file ? req.file.filename : 'default.png';

    try {

        if (!firstName || !lastName || !pass || !email || !phoneNumber  || !dateOfBirth) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        } 


        const Query = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const result = await pool.query(Query, [owner_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist"
            });
        }


        const hashedPassword = await bcrypt.hash(pass, saltRounds);


        const updateQuery = 'UPDATE Petowner SET First_name = $1, Last_name = $2, Password = $3, Email = $4, Phone = $5, Date_of_birth = $6 ,Image=$7 WHERE Owner_Id = $8';
        await pool.query(updateQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth,Image ,owner_id]);

        res.status(200).json({
            status: "Success",
            message: "Account info updated successfully"
        });

    }
    catch (error) {
        console.error("Error updating account info:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



const getinfo=async(req,res)=>{
    const Owner_Id = req.ID; // Assuming req.ID is correctly defined

    try {
        // Check if Owner_Id and Name_Provider are provided
        if (!Owner_Id ) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }



        // Query to check if Petowner exists
        const Query1 = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const res1 = await pool.query(Query1, [Owner_Id]);

        if (res1.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Petowner doesn't exist"
            });
        }


        const q=await pool.query('SELECT First_name,Last_name,Phone,Email,Date_of_birth,Location,Image FROM Petowner WHERE Owner_Id=$1',[Owner_Id]);

        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :q.rows[0]
        });
    }
    catch (error) {
        console.log(error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}


const changePassword = async(req, res) =>{
    const ownerId = req.ID;
    let{oldPassword, newPassword} = req.body;

    try {
        if (!ownerId || !oldPassword || !newPassword) {
            return res.status(400).json({
                status: 'Fail',
                message: 'Please provide ownerId, oldPassword, and newPassword.'
            });
        }

        const query = 'SELECT Password FROM Petowner WHERE Owner_Id = $1';
        const result = await pool.query(query, [ownerId]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: 'Fail',
                message: 'Owner not found.'
            });
        }

        const currentPasswordHash = result.rows[0].password;

        // Compare the old password with the current password hash
        const isMatch = await bcrypt.compare(oldPassword, currentPasswordHash);
        if (!isMatch) {
            return res.status(400).json({
                status: 'Fail',
                message: 'Old password is incorrect.'
            });
        }

        // Hash the new password
        const newPasswordHash = await bcrypt.hash(newPassword, 10);

        // Update the password in the database
        const updateQuery = 'UPDATE Petowner SET Password = $1 WHERE Owner_Id = $2';
        await pool.query(updateQuery, [newPasswordHash, ownerId]);

        res.status(200).json({
            status: 'Success',
            message: 'Password changed successfully.'
        });
        
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        })
        
    }
}

  

module.exports = {
    signUp,
    signIn,
    deleteAccount,
    forgotPassword,
    resetPassword,
    uploadphoto,
    resizePhoto,
    validationCode,
    updateInfo,
    getinfo,
    changePassword,
    validateCodeAndTransfer
   
      
}