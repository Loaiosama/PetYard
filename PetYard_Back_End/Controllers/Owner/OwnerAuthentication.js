const pool = require('../../db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const reset = require('./../../Models/UserModel');
const sendemail = require("./../../Utils/email");

const saltRounds = 10;

const signUp = async (req, res) => {
    const { firstName, lastName, pass, email, phoneNumber, dateOfBirth } = req.body;

    try {

        if (!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const client = await pool.connect();
        const emailExists = 'Select * FROM Petowner WHERE Email = $1';
        const phoneExists = 'Select * FROM Petowner WHERE Phone = $1';
        const resultEmail = await client.query(emailExists, [email]);
        const resultPhone = await client.query(phoneExists, [phoneNumber]);

        if (resultEmail.rows.length === 1 && resultPhone.rows.length === 1) {
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
        else {
            const hashedPassword = await bcrypt.hash(pass, saltRounds);

            const insertQuery = 'Insert INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *';
            const newUser = client.query(insertQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth]);

            res.status(201).json({ message: "Sign up successful" })
        }

        client.release();

    }
    catch (e) {
        console.error("Error during signUp", e);
        res.status(500).json({ error: "Internal server error" });
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

    const owner_id = req.Owner_Id;

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

        const result = await pool.query('SELECT * FROM Petowner WHERE email = $1', [email]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email"
            });
        }

        const { resetToken} = reset.CreatePasswordResetToken();

    

        const resetURL = `${req.protocol}://${req.get('host')}/api/v1/users/resetPassword/${resetToken}`;

        const message = `Forgot Your password? Submit A put request with your new password and  passwordConfirm to: ${resetURL}.\n If you didnt forget your password, please ignore this email!`;

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

    const hashedToken = crypto.createHash('sha256').update(req.params.token).digest('hex'); 
    const {PasswordResetExpires } = reset.CreatePasswordResetToken();

   

    if(PasswordResetExpires >= Date.now() && hashedToken)
    {
        const {pass,email}=req.body;
        if(!pass)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide password"
            });
        }

        const hashedPassword = await bcrypt.hash(pass, saltRounds);
        const newpass = 'UPDATE Petowner SET Password = $1 WHERE Email = $2';
        await pool.query(newpass, [hashedPassword, email]);  
        res.status(200).json({ message: "Password Changed correctly" });
    
    }

    else{

       return res.status(400).json({
        status : "Fail",
        Message : "Token is invalid or has expired"
       });
    }
    
}



module.exports = {
    signUp,
    signIn,
    deleteAccount,
    forgotPassword,
    resetPassword
}