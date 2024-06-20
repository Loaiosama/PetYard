const pool = require('../../db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const axios = require('axios');
const multer =require('multer');
const sharp = require('sharp');
const saltRounds = 10;
const crypto = require('crypto');//reset pass - forget pass
const Model = require('./../../Models/UserModel');
const sendemail = require("./../../Utils/email");

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

    req.file.filename=`Provider-${req.ID}-${Date.now()}.jpeg`;

    sharp(req.file.buffer).resize(500,500).toFormat('jpeg').jpeg({quality:90}).toFile(`public/img/users/ServiceProvider/${req.file.filename}`);
    next();
}



const signUp = async (req, res) => {
    const { UserName, pass, email, phoneNumber, dateOfBirth, Bio} = req.body;
    // const Image=req.file.filename;
    let Image = req.file ? req.file.filename : 'default.png';
    
    try {

        if(!UserName || !pass || !email || !phoneNumber || !dateOfBirth || !Bio || !Image)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }


        const client = await pool.connect();
        const UserNameExists = 'Select * FROM ServiceProvider WHERE UserName = $1';
        const emailExists = 'Select * FROM ServiceProvider WHERE Email = $1';
        const phoneExists = 'Select * FROM ServiceProvider WHERE Phone = $1';
        const resultUserNameExists = await client.query(UserNameExists, [UserName]);
        const resultEmail = await client.query(emailExists, [email]);
        const resultPhone = await client.query(phoneExists, [phoneNumber]);

        if (resultUserNameExists.rows.length === 1 ) {
            console.log("User already exists");
            res.status(400).json({ message: "User already exists, try another  User_Name." })
        }
        else if (resultEmail.rows.length === 1 && resultPhone.rows.length === 1) {
            console.log("User already exists");
            res.status(400).json({ message: "User already exists, try another Email and Phone number." })
        }
        else if(resultPhone.rows.length === 1)
        {  
            console.log("User already exists");
            res.status(400).json({ message: "User already exists, try another Phone number." })

        }
        else if(resultEmail.rows.length === 1)
        {  
            console.log("User already exists");
            res.status(400).json({ message: "User already exists, try another Email." })

        }
        else
        {

            const hashedPassword = await bcrypt.hash(pass, saltRounds);
            const insertQuery = 'Insert INTO ServiceProvider (UserName, Password, Email, Phone, Date_of_birth,Bio,Image) VALUES ($1, $2, $3, $4, $5, $6,$7) RETURNING *';
            const newUser = client.query(insertQuery, [UserName, hashedPassword, email, phoneNumber, dateOfBirth,Bio,Image]);  
            const {validationCode} = Model.CreateValidationCode();

            const message = `Your Validation code ${validationCode} \n Insert the Validatoin code to enjoy with Our Services`;

            await sendemail.sendemail({
                email: email,
                subject: 'Your Validation code  (valid for 10 min) ',
                message
            });
         res.status(201).json({ message: "Sign up successful" })
        }

        client.release();
        
    }
    catch(e)
    {
        console.error("Error during signUp", e);
        res.status(500).json({ error: "internal server error"});
    }

}
const signIn = async (req, res) => {

    const { UserName, password } = req.body;

    try {
        // Check if both email and password are provided
        if (!UserName || !password) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide UserName and password"
            });
        }

        // Query the database for the user with the provided email and password
        const result = await pool.query('SELECT * FROM ServiceProvider WHERE UserName = $1', [UserName]);
       
        // If user not found
        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect UserName or password"
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

        // Extract the Provider ID from the query result
        const ProviderId = user.provider_id;
        // Generate a JWT token based on the ProviderId ID
        const token = jwt.sign({ ID: ProviderId }, 'your_secret_key', { expiresIn: '24h' });

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

    const provider_id = req.ID;

    try {
        

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const deleteQuery = 'DELETE FROM ServiceProvider WHERE Provider_Id = $1';
        await pool.query(deleteQuery, [provider_id]);

        res.status(200).json({
            status: "Success",
            message: "Account deleted successfully"
        });
    } catch (error) {
        console.error("Error deleting account:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};
const updateInfo = async (req, res) => {

    const provider_id = req.ID;
    const {UserName, pass, email, phoneNumber,dateOfBirth } = req.body;
    const Image=req.file.filename;

    try {


        if(!UserName|| !pass || !email || !phoneNumber || !dateOfBirth )
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist"
            });
        }

        const hashedPassword = await bcrypt.hash(pass, saltRounds);


        const updateQuery = 'UPDATE ServiceProvider SET UserName =$1,  Password = $2, Email = $3, Phone = $4, Date_of_birth = $5 , Image=$6 WHERE Provider_Id = $7';
        await pool.query(updateQuery, [UserName, hashedPassword, email, phoneNumber, dateOfBirth,Image,provider_id]);

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



const forgotPassword = async (req, res) => {
    const { email } = req.body;

    try {
        if (!email) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill Your Email"
            });
        }

        const result = await pool.query('SELECT * FROM ServiceProvider WHERE Email = $1', [email]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email"
            });
        }

        const { resetToken,PasswordResetToken} = Model.CreatePasswordResetToken();

       await pool.query('UPDATE ServiceProvider SET ResetToken = $1 WHERE Email = $2', [PasswordResetToken, email]);

        const resetURL = `${req.protocol}://${req.get('host')}/Provider/Resetpassword/${resetToken}`;

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
        const result = await pool.query('SELECT * FROM ServiceProvider WHERE Email = $1', [email]);
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
    const newpass = 'UPDATE ServiceProvider SET Password = $1 , ResetToken = NULL WHERE Email = $2';
    await pool.query(newpass, [hashedPassword, email]);  
    res.status(200).json({ message: "Password Changed correctly" });
    
   } catch (error) {

    res.status(500).json({ error: "Internal server error" });
   }
}




















const SelectServices = async (req, res) => {
    const provider_id = req.ID;
    const { Type } = req.body;

    try {
        if (!Type) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide the service type"
            });
        }

        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [provider_id]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const getServiceQuery = 'SELECT * FROM Services WHERE Provider_ID = $1';
        const servicesResult = await pool.query(getServiceQuery, [provider_id]);

        const services = servicesResult.rows;

        // Check if the service type already exists for the provider
        const isServiceAlreadySelected = services.some(service => service.type === Type);
        if (isServiceAlreadySelected) {
            return res.status(400).json({
                status: "Fail",
                message: `You have already selected this service before: ${Type}`
            });
        }

        // Add the new service to the database
        const addServiceQuery = 'INSERT INTO Services (Type, Provider_ID) VALUES ($1, $2) RETURNING *';
        const client = await pool.connect();
        const addedService = await client.query(addServiceQuery, [Type, provider_id]);
        client.release();

        res.status(201).json({ 
            status: "Success",
            message: "Service added successfully",
            service: addedService.rows[0]
        });

    } catch (error) {
        console.error("Error adding service:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

const Killservice = async(req,res)=>{
    const provider_id=req.ID;
    const {Service_ID}=req.params;

    try {
        if(!Service_ID)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }
        else{



            const client = await pool.connect();
            const Exists = 'Select * FROM Services WHERE provider_id = $1';
            const result = await client.query(Exists, [provider_id]);
                
            if (result.rows.length === 0) {
                return res.status(401).json({
                    status: "Fail",
                    message: "Provider doesn't exist"
                });
            }
            
        const deleteQuery = 'DELETE FROM Services WHERE Service_ID = $1 AND provider_id = $2 ';
        await pool.query(deleteQuery, [Service_ID,provider_id]);

        res.status(200).json({
            status: "Success",
            message: "Service deleted successfully"
        });

    }
 }catch (error) {
        console.error("Error deleting account:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });


        
    } 
}
const getallservices = async(req,res)=>{
    const provider_id = req.ID;
    try {
        if(!provider_id)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
        }
        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }
        const getAllservices = await pool.query('SELECT * FROM Services WHERE Provider_ID=$1',[provider_id]);
        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :getAllservices.rows
        });
            
    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
    
}
const getService=async(req,res)=>{

    const {Service_ID}=req.params;
    const provider_id = req.ID;
    try {   

        if(!provider_id || !Service_ID)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
        }

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }
        const getservices = await pool.query('SELECT * FROM Services WHERE Provider_ID=$1 AND Service_ID=$2',[provider_id,Service_ID]);
        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :getservices.rows
        });
            
    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}










const startChat =  async (req, res) => {
    const provider_id = req.ID;
   try {

    const client = await pool.connect();
    const Exists = 'Select * FROM ServiceProvider WHERE provider_id = $1';
    const result = await client.query(Exists, [provider_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

 
       const username = result.rows[0].first_name;
       const Email = result.rows[0].email;

     const r =await axios.put(
       "https://api.chatengine.io/users/",
       {username : username+provider_id ,secret :username, first_name:username ,
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
 
}



module.exports = {
    signUp,
    signIn,
    deleteAccount,
    uploadphoto,
    resizePhoto,
    updateInfo,
    SelectServices,
    Killservice,
    startChat,
    getallservices,
    getService,
    forgotPassword,
    resetPassword
    
  
    
};