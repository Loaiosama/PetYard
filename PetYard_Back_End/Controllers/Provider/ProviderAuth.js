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
const resizePhotoProduct=(req,res,next)=>{

    if(!req.file) return next();

    req.file.filename=`Products-${req.ID}-${Date.now()}.jpeg`;

    sharp(req.file.buffer).resize(500,500).toFormat('jpeg').jpeg({quality:90}).toFile(`public/img/Products/${req.file.filename}`);
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
            const insertQuery = 'Insert INTO ServiceProvider (First_name, Last_name, Password, Email, Phone, Date_of_birth,Bio,Image) VALUES ($1, $2, $3, $4, $5, $6,$7,$8) RETURNING *';
            const newUser = client.query(insertQuery, [firstName, lastName, hashedPassword, email, phoneNumber, dateOfBirth,Bio,Image]);  
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
const updateInfo = async (req, res) => {

    const provider_id = req.ID;
    const {firstName, lastName, pass, email, phoneNumber,dateOfBirth } = req.body;
    const Image=req.file.filename;

    try {


        if(!firstName || !lastName || !pass || !email || !phoneNumber || !dateOfBirth )
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

        const updateQuery = 'UPDATE ServiceProvider SET First_name = $1, Last_name = $2, Password = $3, Email = $4, Phone = $5, Date_of_birth = $6 , Image=$7 WHERE Provider_Id = $8';
        await pool.query(updateQuery, [firstName, lastName, pass, email, phoneNumber, dateOfBirth,Image,provider_id]);

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


const SelectServices = async(req,res)=>{

    const provider_id = req.ID;
    const {Type} = req.body;
    try {

        if(!Type)
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
                message: "User doesn't exist."
            });
        }





        const getservices= await pool.query('SELECT * FROM Services WHERE Provider_ID=$1 ',[provider_id]);
        const services = getservices.rows;
        // Check if the service type already exists for the provider
        const isServiceAlreadySelected = services.some(service => service.type === Type);
        if (isServiceAlreadySelected) {
            return res.status(400).json({
                status: "Fail",
                message: `You have already selected this service before: ${Type}`
            });
        }


             // Add the new service to the database
         const client = await pool.connect();
         const addserviceQuery = 'INSERT INTO Services (Type, provider_id) VALUES ($1, $2) RETURNING *';
         client.release();
         res.status(201).json({ message: "Add Service successful" })
      

    } catch (error) {
        console.error("Error updating account info:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
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






const CreateSlot = async (req, res) => {
    const { Price, Start_time, End_time } = req.body;
    const Service_ID = req.params.Service_ID;
    const provider_id = req.ID;

    try {
        if (!Price || !Start_time || !End_time || !Service_ID || !provider_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Missing required information"
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
        
        const client = await pool.connect();
        const addslotQuery = 'INSERT INTO ServiceSlots (Service_ID, Provider_ID, Price, Start_time, End_time) VALUES ($1, $2, $3, $4, $5) RETURNING *';
        client.release();
        res.status(201).json({ message: "Slot added successfully" });

    } catch (error) {
        console.error("Error adding slot:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};
const GetAllSlots=async(req,res)=>{
  const provider_id = req.ID;
  try {

    if (!provider_id) {
        return res.status(400).json({
            status: "Fail",
            message: "Missing required information"
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

    const getallslot=await pool.query('SELECT * FROM ServiceSlots WHERE Provider_ID=$1 ',[provider_id]);
    res.status(200).json({
        status :"Done",
        message : "One Data Is Here",
        data :getallslot.rows
    });
    
    
  } catch (error) {
    res.status(500).json({
        status: "Fail",
        message: "Internal server error"
    });
  }



}
const GetSlot =async(req,res)=>
{
    const provider_id = req.ID;
    const {Slot_ID}=req.params;
    try {   

        if(!provider_id || !Slot_ID)
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
        



        const getslot = await pool.query('SELECT * FROM ServiceSlots WHERE Provider_ID=$1 AND Slot_ID=$2',[provider_id,Slot_ID]);
        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :getslot.rows
        });
            
    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
const DeleteSlot = async(req,res)=>{
    const {Slot_ID}=req.params;
    const provider_id = req.ID;
    try {   

        if(!Slot_ID||!provider_id)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Happen"
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

        const deleteQuery = 'DELETE FROM ServiceSlots WHERE Slot_ID=$1';
        await pool.query(deleteQuery, [Slot_ID]);
       
        res.status(200).json({
            status: "Success",
            message: "Slot deleted successfully"
        });
            
    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
const UpdateSlot=async(req,res)=>{
    const {Slot_ID}=req.params;
    const {Start_time,End_time,Price}=req.body;
    const provider_id = req.ID;
 
    try {   

        if (!Slot_ID || !Start_time || !End_time || !Price) 
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Errors Happen"
            });
        }

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const res = await pool.query(Query, [provider_id]);

        if (res.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }




        const updateQuery = 'UPDATE ServiceSlots SET_time=$1 Start, End_time=$2, Price=$3 WHERE Slot_ID = $4';
        const result = await pool.query(updateQuery, [Start_time, End_time, Price, Slot_ID]);

        if (result.rowCount === 0) {
            // If no rows were updated, return a failure response
            return res.status(404).json({
                status: "Fail",
                message: "Slot not found"
            });
        }

        // Respond with success message
        res.status(200).json({
            status: "Success",
            message: "Slot updated successfully"
        });
            
    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}


















const Add_Product = async (req, res) => {
    const provider_id = req.ID;
    const { name, description, Type, brand, Price, stock_quantity } = req.body;
    const Image=req.file.filename;

    try {
        if (!provider_id || !name || !description || !Type || !brand || !Price || !stock_quantity || !Image) {
            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }

        const userQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const userResult = await pool.query(userQuery, [provider_id]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const insertQuery = 'INSERT INTO Products (name, description, Type, brand, Price, stock_quantity, Image,provider_id) VALUES ($1, $2, $3, $4, $5, $6, $7,$8) RETURNING *';
        const productResult = await pool.query(insertQuery, [name, description, Type, brand, Price, stock_quantity, Image,provider_id]);

        res.status(201).json({ message: "Product added successfully", product: productResult.rows[0] });
    } catch (error) {
        console.error("Error adding product:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
const GetAllProduct =async(req,res)=>{
    const provider_id=req.ID;
    try {

        if (!provider_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }

        const userQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const userResult = await pool.query(userQuery, [provider_id]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }


        const GetAllProduct=await pool.query('SELECT * FROM Products WHERE Provider_ID=$1',[provider_id]);


        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :GetAllProduct.rows

        });
        
    } catch (error) {
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }


}
const GetProduct = async (req, res) => {
    const Provider_Id = req.ID;
    const Product_Id = req.params.Product_Id; 
    try {
        if (!Provider_Id || !Product_Id) {
            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }

        const userQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const userResult = await pool.query(userQuery, [Provider_Id]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const getProduct = await pool.query('SELECT * FROM Products WHERE Provider_ID = $1 AND product_id = $2', [Provider_Id, Product_Id]);

        res.status(200).json({
            status: "Done",
            message: "Data retrieved successfully",
            data: getProduct.rows
        });
    } catch (error) {
        console.error("Error retrieving product:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
const UpdateProduct = async (req, res) => {
    const provider_id = req.ID;
    const Product_Id = req.params.Product_Id;
    const { name, description, Type, brand, Price, stock_quantity } = req.body;
    const Image = req.file.filename;

    try {
        // Check if any required fields are missing
        if (!provider_id || !Product_Id || !name || !description || !Type || !brand || !Price || !stock_quantity || !Image) {
            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }

        // Check if the provider exists
        const userQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const userResult = await pool.query(userQuery, [provider_id]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        // Update the product based on Product_Id and Provider_Id
        const updateQuery = 'UPDATE Products SET name=$1, description=$2, Type=$3, brand=$4, Price=$5, stock_quantity=$6, Image=$7 WHERE product_id=$8 AND Provider_ID=$9';
        const result = await pool.query(updateQuery, [name, description, Type, brand, Price, stock_quantity, Image, Product_Id, provider_id]);

        if (result.rowCount === 0) {
            // If no rows were updated, return a failure response
            return res.status(404).json({
                status: "Fail",
                message: "Product not found or update failed"
            });
        }

        // Respond with success message
        res.status(200).json({
            status: "Success",
            message: "Product updated successfully"
        });
    } catch (error) {
        console.error("Error updating product:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}
const RemoveProduct= async(req,res)=>{
    const provider_id = req.ID;
    const Product_Id = req.params.Product_Id;
    try {

        if(!provider_id || !Product_Id)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }
         // Check if the provider exists
         const userQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
         const userResult = await pool.query(userQuery, [provider_id]);
 
         if (userResult.rows.length === 0) {
             return res.status(401).json({
                 status: "Fail",
                 message: "User doesn't exist."
             });
         }

         const deleteQuery = 'DELETE FROM Products WHERE Provider_ID=$1 AND product_id=$2';
         await pool.query(deleteQuery, [provider_id,Product_Id]);
        
         res.status(200).json({
             status: "Success",
             message: "Product deleted successfully"
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
    CreateSlot,
    GetAllSlots,
    GetSlot,
    DeleteSlot,
    UpdateSlot,
    Add_Product,
    resizePhotoProduct,
    GetAllProduct,
    GetProduct,
    UpdateProduct,
    RemoveProduct
    
};