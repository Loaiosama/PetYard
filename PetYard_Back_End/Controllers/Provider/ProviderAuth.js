const pool = require('../../db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const saltRounds=10;


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

    req.file.filename=`Provider-${req.ID}-${Date.now()}.jpeg`;

    sharp(req.file.buffer).resize(500,500).toFormat('jpeg').jpeg({quality:90}).toFile(`public/img/users/ServiceProvider/${req.file.filename}`);
    next();
}



const signUp = async (req, res) => {
    const { firstName, lastName, pass, email, phoneNumber, dateOfBirth, Bio} = req.body;
    
    const Image=req.file.filename;
    try {


        if(!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth || !Bio)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }


        const client = await pool.connect();
        const emailExists = 'Select * FROM ServiceProvider WHERE Email = $1';
        const phoneExists = 'Select * FROM ServiceProvider WHERE Phone = $1';
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
        else
        {

            const hashedPassword = await bcrypt.hash(pass, saltRounds);
            
            const insertQuery = 'Insert INTO ServiceProvider (First_name, Last_name, Password, Email, Phone, Date_of_birth, Bio, Image) VALUES ($1, $2, $3, $4, $5, $6, $7,$8) RETURNING *';
            const newUser = client.query(insertQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth, Bio,Image]);

            res.status(201).json({ message: "Sign up successful" })
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
        const result = await pool.query('SELECT * FROM ServiceProvider WHERE email = $1', [email]);
       
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

module.exports = {
    signUp,
    signIn,
    deleteAccount,
    uploadphoto,
    resizePhoto
};