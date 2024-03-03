const pool = require('../db');
const jwt = require('jsonwebtoken');

const signUp = async (req, res) => {
    const { firstName, lastName, pass, email, phoneNumber, dateOfBirth} = req.body;

    try {

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



module.exports = {
    signUp

}