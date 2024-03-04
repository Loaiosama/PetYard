const pool = require('../db');
const jwt = require('jsonwebtoken');

const signUp = async (req, res) => {
    const { firstName, lastName, pass, email, phoneNumber, dateOfBirth} = req.body;

    try {

        if(!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const client = await pool.connect();
        const existQuery = 'Select * FROM Petowner WHERE Email = $1';
        const result = await client.query(existQuery, [email]);

        if(result.rows.length === 1)
        {
            console.log("User already exists");
            res.status(400).json({message : "User already exists, try another Email."})
        }
        else{

           
            const insertQuery = 'Insert INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *';
            const newUser = client.query(insertQuery, [firstName, lastName, pass, email, phoneNumber, dateOfBirth]);

            res.json({ message: "Sign up successful" })
        }

        client.release();
        
    }
    catch(e)
    {
        console.error("Error during signUp", e);
        res.status(500).json({ error: "Internal server error"});
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
        const isPasswordMatch = user.password === password; // You should use bcrypt for secure password comparison

        if (!isPasswordMatch) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email or password"
            });
        }

        // Extract the owner ID from the query result
        const ownerId = user.owner_id;

        // Generate a JWT token based on the owner ID
        const token = jwt.sign({ owner_id: ownerId }, 'your_secret_key ', { expiresIn: '24h' });

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
    const { Email, Password } = req.body;

    try {
        if (!Email || !Password) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide email and password"
            });
        }

        const result = await pool.query('SELECT * FROM Petowner WHERE email = $1 AND password = $2', [Email, Password]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Incorrect email or password"
            });
        }

        const deleteQuery = 'DELETE FROM Petowner WHERE email = $1';
        await pool.query(deleteQuery, [Email]);

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





module.exports = {
    signUp,
    signIn,
    deleteAccount
}