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

// const signUp = async (req, res) => {
//     const { firstName, lastName, pass, email, phoneNumber,dateOfBirth } = req.body;
//     let Image = req.file ? req.file.filename : 'default.png';
//     try {

//         if (!firstName || !lastName || !pass || !email || !phoneNumber  || !dateOfBirth) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please Fill All Information"
//             });
//         } 

//         const client = await pool.connect();
//         const emailExists = 'Select * FROM Petowner WHERE Email = $1';
//         const phoneExists = 'Select * FROM Petowner WHERE Phone = $1';
//         const resultEmail = await client.query(emailExists, [email]);
//         const resultPhone = await client.query(phoneExists, [phoneNumber]);

//         if (resultEmail.rows.length === 1 && resultPhone.rows.length === 1) {
//             console.log("User already exists");
//             res.status(400).json({ message: "User already exists, try another Email and Phone number." })
//         }
//         else if(resultPhone.rows.length === 1)
//         {  
//             console.log("User already exists");
//             res.status(400).json({ message: "User already exists, try another Phone number." })

//         }
//         else if(resultEmail.rows.length === 1)
//         {  
//             console.log("User already exists");
//             res.status(400).json({ message: "User already exists, try another Email." })

//         }
//         else {
//             const hashedPassword = await bcrypt.hash(pass, saltRounds);

//             const insertQuery = 'Insert INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth,Image) VALUES ($1, $2, $3, $4, $5, $6,$7) RETURNING *';
//             const newUser = client.query(insertQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth,Image]);


            
//         const {validationCode} = Model.CreateValidationCode();

//         const message = `Your Validation code ${validationCode} \n Insert the Validatoin code to enjoy with Our Services`;

//         await sendemail.sendemail({
//             email: email,
//             subject: 'Your Validation code  (valid for 10 min) ',
//             message
//         });

//             res.status(201).json({
//                  message: "Sign up successful" 
//             })
//         }

//         client.release();
 
//     }
//     catch (e) {
//         console.error("Error during signUp", e);
//         res.status(500).json({ error: "Internal server error" });
//     }
// }

// const signUp = async (req, res) => {
//     const { firstName, lastName, pass, email, phoneNumber, dateOfBirth } = req.body;
//     let Image = req.file ? req.file.filename : 'default.png';
//     try {
//         if (!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please Fill All Information"
//             });
//         }

//         const client = await pool.connect();
//         const emailExists = 'SELECT * FROM Petowner WHERE Email = $1';
//         const phoneExists = 'SELECT * FROM Petowner WHERE Phone = $1';
//         const resultEmail = await client.query(emailExists, [email]);
//         const resultPhone = await client.query(phoneExists, [phoneNumber]);

//         if (resultEmail.rows.length > 0 || resultPhone.rows.length > 0) {
//             let message = "User already exists, try another ";
//             if (resultEmail.rows.length > 0) message += "Email ";
//             if (resultPhone.rows.length > 0) message += "Phone number ";
//             return res.status(400).json({ message: message.trim() + "." });
//         } else {
//             const hashedPassword = await bcrypt.hash(pass, saltRounds);
//             const { validationCode, validationCodeExpires } = Model.CreateValidationCode();

//             const insertQuery = `
//                 INSERT INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth, Image, validation_code, validation_code_expires)
//                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`;
//             await client.query(insertQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth, Image, validationCode, validationCodeExpires]);

//             const message = `Your Validation code is ${validationCode}. Insert the Validation code to enjoy our services.`;

//             await sendemail.sendemail({
//                 email: email,
//                 subject: 'Your Validation code (valid for 10 min)',
//                 message
//             });

//             res.status(201).json({
//                 message: "Sign up initiated. Please check your email for the validation code."
//             });
//         }

//         client.release();
//     } catch (e) {
//         console.error("Error during signUp", e);
//         res.status(500).json({ error: "Internal server error" });
//     }
// };

// const signUp = async (req, res) => {
//     const { firstName, lastName, pass, email, phoneNumber, dateOfBirth } = req.body;
//     let Image = req.file ? req.file.filename : 'default.png';
//     try {
//         if (!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please Fill All Information"
//             });
//         }

//         const client = await pool.connect();
//         const emailExists = 'SELECT * FROM Petowner WHERE Email = $1';
//         const phoneExists = 'SELECT * FROM Petowner WHERE Phone = $1';
//         const resultEmail = await client.query(emailExists, [email]);
//         const resultPhone = await client.query(phoneExists, [phoneNumber]);

//         if (resultEmail.rows.length > 0) {
//             res.status(400).json({ message: "User already exists with this email." });
//         } else if (resultPhone.rows.length > 0) {
//             res.status(400).json({ message: "User already exists with this phone number." });
//         } else {
//             const { validationCode, validationCodeExpires } = Model.CreateValidationCode();

//             // Temporarily store user data and validation code
//             const tempUserData = {
//                 firstName,
//                 lastName,
//                 pass,
//                 email,
//                 phoneNumber,
//                 dateOfBirth,
//                 Image,
//                 validationCode,
//                 validationCodeExpires
//             };
            
//             // Store user data temporarily (use Redis, memory store, etc.)
//             // Example: await redisClient.set(email, JSON.stringify(tempUserData), 'EX', 600); // Set expiry of 10 minutes

//             await someTempStore.set(email, tempUserData, { EX: 600 });

//             const message = `Your Validation code ${validationCode} \n Insert the Validation code to enjoy our services`;

//             await sendemail.sendemail({
//                 email: email,
//                 subject: 'Your Validation code (valid for 10 min)',
//                 message
//             });

//             res.status(201).json({
//                 message: "Sign up initiated. Please verify your email."
//             });
//         }

//         client.release();

//     } catch (e) {
//         console.error("Error during signUp", e);
//         res.status(500).json({ error: "Internal server error" });
//     }
// }


// const validateCode = async (req, res) => {
//     const { email, code } = req.body;
//     try {
//         if (!email || !code) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please provide email and validation code"
//             });
//         }

//         const client = await pool.connect();
//         const result = await client.query('SELECT * FROM Petowner WHERE Email = $1', [email]);

//         if (result.rows.length === 0) {
//             return res.status(401).json({
//                 status: "Fail",
//                 message: "User not found"
//             });
//         }

//         const user = result.rows[0];
//         if (user.validation_code !== code || user.validation_code_expires < new Date()) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Invalid or expired validation code"
//             });
//         }

//         const updateQuery = `
//             UPDATE Petowner
//             SET validation_code = NULL, validation_code_expires = NULL
//             WHERE Email = $1`;
//         await client.query(updateQuery, [email]);

//         res.status(200).json({
//             status: "Success",
//             message: "Validation successful. You can now log in."
//         });

//         client.release();
//     } catch (error) {
//         console.error("Error validating code:", error);
//         res.status(500).json({ error: "Internal server error" });
//     }
// };

// const signUp = async (req, res) => {
//     const { firstName, lastName, pass, email, phoneNumber, dateOfBirth } = req.body;
//     let Image = req.file ? req.file.filename : 'default.png';
//     try {
//         if (!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please Fill All Information"
//             });
//         }

//         const client = await pool.connect();
//         const emailExists = 'SELECT * FROM Petowner WHERE Email = $1';
//         const phoneExists = 'SELECT * FROM Petowner WHERE Phone = $1';
//         const resultEmail = await client.query(emailExists, [email]);
//         const resultPhone = await client.query(phoneExists, [phoneNumber]);

//         if (resultEmail.rows.length > 0) {
//             res.status(400).json({ message: "User already exists with this email." });
//         } else if (resultPhone.rows.length > 0) {
//             res.status(400).json({ message: "User already exists with this phone number." });
//         } else {
//             const { validationCode, validationCodeExpires } = Model.CreateValidationCode();

//             const tempUserData = {
//                 firstName,
//                 lastName,
//                 pass,
//                 email,
//                 phoneNumber,
//                 dateOfBirth,
//                 Image,
//                 validationCode,
//                 validationCodeExpires
//             };

//             await redisClient.set(email, JSON.stringify(tempUserData), 'EX', 600); // Set expiry of 10 minutes

//             const message = `Your Validation code ${validationCode} \n Insert the Validation code to enjoy our services`;

//             await sendemail.sendemail({
//                 email: email,
//                 subject: 'Your Validation code (valid for 10 min)',
//                 message
//             });

//             res.status(201).json({
//                 message: "Sign up initiated. Please verify your email."
//             });
//         }

//         client.release();

//     } catch (e) {
//         console.error("Error during signUp", e);
//         res.status(500).json({ error: "Internal server error" });
//     }
// };
// const validateCode = async (req, res) => {
//     const { email, code } = req.body;

//     try {
//         if (!email || !code) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please provide email and validation code"
//             });
//         }

//         const tempUserData = await redisClient.get(email);

//         if (!tempUserData) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Validation code expired or invalid"
//             });
//         }

//         const userData = JSON.parse(tempUserData);

//         if (userData.validationCode !== code || userData.validationCodeExpires < Date.now()) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Invalid or expired validation code"
//             });
//         }

//         const hashedPassword = await bcrypt.hash(userData.pass, saltRounds);

//         const client = await pool.connect();
//         const insertQuery = 'INSERT INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth, Image) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
//         const newUser = await client.query(insertQuery, [userData.firstName, userData.lastName, hashedPassword, userData.email, userData.phoneNumber, userData.dateOfBirth, userData.Image]);

//         client.release();

//         res.status(201).json({
//             message: "Sign up successful",
//             user: newUser.rows[0]
//         });

//         await redisClient.del(email);

//     } catch (e) {
//         console.error("Error during validation", e);
//         res.status(500).json({ error: "Internal server error" });
//     }
// };

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
        const validationCode = crypto.randomBytes(3).toString('hex'); // Generate validation code

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


const CreateChat = async (req, res) => {
    const Name_Provider = req.params.name_provider;
    const Owner_Id = req.ID; // Assuming req.ID is correctly defined

    try {
        // Check if Owner_Id and Name_Provider are provided
        if (!Owner_Id || !Name_Provider) {
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

        // Query to check if ServiceProvider exists
        const Query2 = 'SELECT * FROM ServiceProvider WHERE UserName = $1';
        const res2 = await pool.query(Query2, [Name_Provider]);

        if (res2.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "ServiceProvider doesn't exist"
            });
        }
    
        const provider_id=res2.rows[0].provider_id;
        // Insert new Chat record with Provider_ID and Owner_Id
        const client = await pool.connect();
        const startChat = 'INSERT INTO Chat (Provider_ID, Owner_Id) VALUES ($1, $2) RETURNING *';
        const NewChat = await client.query(startChat, [provider_id, Owner_Id]);
        client.release();

        // Respond with success message
        res.status(200).json({
            status: "Success",
            message: "Chat created successfully"
        });

    } catch (error) {
        console.error("Error creating chat:", error);
        res.status(500).json({ error: "Internal server error" });
    }
}

const GetChat =async (req,res)=>
{
    const chat_id=req.params.chat_id;
    try {

        if (!chat_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const GetChat=await pool.query('SELECT * From Chat Where Chat_ID=$1',[chat_id]);


        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :GetChat.rows
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

/*const startChat =  async (req, res) => {
     const owner_id = req.ID;
    try {
        const Query = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const result = await pool.query( Query, [owner_id]); 
       
        const username = result.rows[0].first_name;
        const Email = result.rows[0].email;

      const r =await axios.put(
        "https://api.chatengine.io/users/",
        {username : username+owner_id ,secret :username, first_name:username ,
            email: Email},
        {"headers":{"private-key":"9b5d6df8-7257-4993-9642-45017512c89d"}}
      );
      return res.status(r.status).json(r.data);
    } catch (error) {
      if (error.response && error.response.status) {
          return res.status(error.response.status).json(error.response.data);
      } else {
         
          return res.status(500).json({ message: 'Internal Server Error' });
      }
  }
  
};
  */


  

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
    CreateChat,
    GetChat,
    getinfo,
    validateCodeAndTransfer
   
      
}