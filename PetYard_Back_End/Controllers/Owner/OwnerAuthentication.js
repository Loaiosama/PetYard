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
    const { firstName, lastName, pass, email, phoneNumber,dateOfBirth } = req.body;
    let Image = req.file ? req.file.filename : 'default.png';
    try {

        if (!firstName || !lastName || !pass || !email || !phoneNumber  || !dateOfBirth) {
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

            const insertQuery = 'Insert INTO Petowner (First_name, Last_name, Password, Email, Phone, Date_of_birth,Image) VALUES ($1, $2, $3, $4, $5, $6,$7) RETURNING *';
            const newUser = client.query(insertQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth,Image]);


            
        const {validationCode} = Model.CreateValidationCode();

        const message = `Your Validation code ${validationCode} \n Insert the Validatoin code to enjoy with Our Services`;

        await sendemail.sendemail({
            email: email,
            subject: 'Your Validation code  (valid for 10 min) ',
            message
        });

            res.status(201).json({
                 message: "Sign up successful" 
            })
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

        const updateQuery = 'UPDATE Petowner SET First_name = $1, Last_name = $2, Password = $3, Email = $4, Phone = $5, Date_of_birth = $6 ,Image=$7 WHERE Owner_Id = $8';
        await pool.query(updateQuery, [firstName, lastName, pass, email, phoneNumber, dateOfBirth,Image ,owner_id]);

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



const MakeOrder = async (req, res) =>{
    const owner_id = req.ID; // Assuming req.ID correctly provides the owner_id

    try {
        // Check if the pet owner with the specified owner_id exists
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        // Insert a new order for the pet owner
        const client = await pool.connect();
        const queryInsertOrder = `
            INSERT INTO Orders (Owner_ID, total_amount, order_date)
            VALUES ($1, $2, CURRENT_TIMESTAMP)
            RETURNING *
        `;
        const resultInsertOrder = await client.query(queryInsertOrder, [owner_id, 0]); // Assuming initial total_amount is 0
        client.release();
        

        res.status(200).json({
            status: "Success",
            message: "Order created successfully",
            order: resultInsertOrder.rows[0]
        });

    } catch (error) {
        console.error("Error making order:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};
const GetAllOrders=async(req,res)=>{
    const owner_id = req.ID; 
    try {
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        const GetAllOrders=await pool.query('SELECT * FROM Orders WHERE Owner_ID=$1',[owner_id]);

        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :GetAllOrders.rows

        });
        
    } catch (error) {
        res.status(500).json({ error: "Internal server error" });
    }

}
const GetOrder=async(req,res)=>{
    const owner_id = req.ID; 
    const order_id=req.params.order_id;
    try {
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        const GetOrder=await pool.query('SELECT * FROM Orders WHERE Owner_ID=$1 AND order_id=$2 ',[owner_id,order_id]);

        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data : GetOrder.rows

        });
        
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: "Internal server error" });
    }


}
const DeleteOrder=async(req,res)=>{
    const owner_id = req.ID; 
    const order_id=req.params.order_id;
    try {

        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }
        const deleteQuery = 'DELETE FROM Orders WHERE Owner_Id = $1 AND order_id=$2';
        await pool.query(deleteQuery, [owner_id,order_id]);

        res.status(200).json({
            status: "Success",
            message: "Order Deleted successfully"
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


const SearchByname = async (req, res) => {
    const owner_id = req.ID; 
    const { name } = req.body;

    try {
        // Check if the pet owner with the specified owner_id exists
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        if (!name) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide a valid name"
            });   
        }

        // Search products by Type
        const querySearch = 'SELECT * FROM Products WHERE "name" = $1'; // Use double quotes for column names with uppercase letters
        const searchResult = await pool.query(querySearch, [name]);

        res.status(200).json({
            status: "Success",
            message: "Search results found",
            data: searchResult.rows
        });

    } catch (error) {
        console.error("Error searching by category:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

const SearchBycategory = async (req, res) => {
    const owner_id = req.ID;
    const { Type } = req.body;

    try {
        // Check if the pet owner with the specified owner_id exists
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        if (!Type) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide a valid Type"
            });
        }

        // Search products by Type using proper SQL syntax
        const querySearch = 'SELECT * FROM Products WHERE Type = $1'; // Use double quotes for column names with uppercase letters
        const searchResult = await pool.query(querySearch, [Type]);

        res.status(200).json({
            status: "Success",
            message: "Search results found",
            data: searchResult.rows
        });

    } catch (error) {
        console.error("Error searching by category:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

const SearchBybrand = async (req, res) => {
    const owner_id = req.ID;
    const { brand } = req.body;

    try {
        // Check if the pet owner with the specified owner_id exists
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        if (!brand) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide a valid Type"
            });
        }

        // Search products by Type using proper SQL syntax
        const querySearch = 'SELECT * FROM Products WHERE brand = $1'; // Use double quotes for column names with uppercase letters
        const searchResult = await pool.query(querySearch, [brand]);

        res.status(200).json({
            status: "Success",
            message: "Search results found",
            data: searchResult.rows
        });

    } catch (error) {
        console.error("Error searching by brand:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



const AddOrderItem = async (req, res) => {
    const owner_id = req.ID;
    const order_id = req.params.order_id;
    const product_id = req.params.product_id;
    const { name, description, Type, brand, price, quantity } = req.body;

    try {
        // Check if the pet owner with the specified owner_id exists
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [owner_id]);

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        if (!quantity || !order_id || !product_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all required information"
            });
        }

        const querySearch = 'SELECT * FROM Products WHERE product_id = $1';
        const searchResult = await pool.query(querySearch, [product_id]);

        // Check if search result is empty or undefined
        if (!searchResult.rows || searchResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Product not found"
            });
        }

        const Quantity = searchResult.rows[0].stock_quantity;

        if (Quantity < quantity) {
            return res.status(400).json({
                status: "Fail",
                message: "Requested quantity exceeds available stock"
            });
        }

        const stock = Quantity - quantity;

        // Update the product details in the Products table
        const updateProductQuery = `
            UPDATE Products 
            SET name = $1, description = $2, Type = $3, brand = $4, Price = $5, stock_quantity = $6
            WHERE product_id = $7
        `;
        await pool.query(updateProductQuery, [name, description, Type, brand, price, stock, product_id]);

        const Price = searchResult.rows[0].price;
        const price_per_unit = quantity * Price;
    
        // Insert the order item into the OrderItems table
        const insertOrderItemQuery = `
            INSERT INTO OrderItems (order_id, product_id, quantity, price_per_unit)
            VALUES ($1, $2, $3, $4)
            RETURNING *
        `;
        const resultInsertOrderItem = await pool.query(insertOrderItemQuery, [order_id, product_id, quantity, price_per_unit]);

        // Update the total_amount in the Orders table
        const getOrderQuery = 'SELECT * FROM Orders WHERE Owner_ID = $1 AND order_id = $2';
        const getOrderResult = await pool.query(getOrderQuery, [owner_id, order_id]);

        const oldTotal = getOrderResult.rows[0].total_amount;
        const newTotal = oldTotal + price_per_unit;

        // Update the total_amount in the Orders table
        const updateOrderQuery = `
            UPDATE Orders 
            SET total_amount = $1, order_date = NOW() 
            WHERE order_id = $2 AND Owner_ID = $3
        `;
        await pool.query(updateOrderQuery, [newTotal, order_id, owner_id]);

        res.status(200).json({
            status: "Success",
            message: "Order item added successfully",
            orderItem: resultInsertOrderItem.rows[0]
        });

    } catch (error) {
        console.error("Error adding order item:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};
















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
    MakeOrder,
    GetAllOrders ,
    GetOrder,
    DeleteOrder,
    SearchByname,
    SearchBycategory,
    SearchBybrand,
    AddOrderItem
    
}