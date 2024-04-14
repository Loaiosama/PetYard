const pool = require('../../db');
const { query } = require('express');
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

const resizePhotoProduct=(req,res,next)=>{

    if(!req.file) return next();

    req.file.filename=`Products-${req.ID}-${Date.now()}.jpeg`;

    sharp(req.file.buffer).resize(500,500).toFormat('jpeg').jpeg({quality:90}).toFile(`public/img/Products/${req.file.filename}`);
    next();
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

module.exports = {
    
    Add_Product,
    uploadphoto,
    resizePhotoProduct,
    GetAllProduct,
    GetProduct,
    UpdateProduct,
    RemoveProduct
    
};