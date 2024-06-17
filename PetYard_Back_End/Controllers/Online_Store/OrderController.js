const pool = require('../../db');
const { query } = require('express');


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
        const getitem=await pool.query('SELECT * FROM OrderItems WHERE order_id=$1 ',[order_id]);
        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data : GetOrder.rows,
            item : getitem.rows

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
    const { quantity } = req.body;
   
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
        const name=searchResult.rows[0].name;
        const description=searchResult.rows[0].description;
        const brand=searchResult.rows[0].brand;
        const price=searchResult.rows[0].price;


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
            SET name = $1, description = $2,  brand = $3, Price = $4, stock_quantity = $5 
            WHERE product_id = $6
        `;
        await pool.query(updateProductQuery, [name, description, brand, price, stock, product_id]);

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



const UpdateOrderItem = async (req, res) => {
    const owner_id = req.ID;
    const order_id = req.params.order_id;
    const product_id = req.params.product_id;
    const order_item_id = req.params.order_item_id;
    const { quantity } = req.body;

   
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

        if (!order_item_id || !quantity || !order_id || !product_id) {
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
        const name=searchResult.rows[0].name;
        const description=searchResult.rows[0].description;
        const brand=searchResult.rows[0].brand;
        const price=searchResult.rows[0].price;


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
            SET name = $1, description = $2,  brand = $3, Price = $4, stock_quantity = $5 
            WHERE product_id = $6
        `;
        await pool.query(updateProductQuery, [name, description, brand, price, stock, product_id]);

        const Price = searchResult.rows[0].price;
        const price_per_unit = quantity * Price;

        const selectq=await pool.query('SELECT * FROM OrderItems WHERE order_item_id = $1 AND order_id=$2 AND product_id=$3',[order_item_id, order_id, product_id]);
        const oldquantity=selectq.rows[0].quantity;
  
        const updateQuery = `
        UPDATE OrderItems 
        SET quantity = $1, price_per_unit = $2
        WHERE order_item_id = $3 AND order_id=$4 AND product_id=$5
    `;
        await pool.query(updateQuery, [quantity, price_per_unit, order_item_id, order_id, product_id]);


        // Update the total_amount in the Orders table
        const getOrderQuery = 'SELECT * FROM Orders WHERE Owner_ID = $1 AND order_id = $2';
        const getOrderResult = await pool.query(getOrderQuery, [owner_id, order_id]);

        const oldTotal = getOrderResult.rows[0].total_amount;
        let newTotal=0;
        

        if(quantity>oldquantity){
             newTotal = oldTotal + price_per_unit;
        }
        else if(quantity<oldquantity){

             newTotal = oldTotal-price_per_unit;
         }
         else if(quantity===oldquantity)
         {
            
            newTotal = oldTotal;
         }
        

        // Update the total_amount in the Orders table
        const updateOrderQuery = `
            UPDATE Orders 
            SET total_amount = $1, order_date = NOW() 
            WHERE order_id = $2 AND Owner_ID = $3
        `;
        await pool.query(updateOrderQuery, [newTotal, order_id, owner_id]);

        res.status(200).json({
            status: "Success",
            message: "Order item Update successfully",
        });

    } catch (error) {
        console.error("Error :", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};





const RemoveOrderItem = async (req, res) => {
    const owner_id = req.ID;
    const order_id = req.params.order_id;
    const product_id = req.params.product_id;
    const order_item_id = req.params.order_item_id;

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

        if (!order_id || !product_id || !order_item_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all required information"
            });
        }

        // Retrieve the order item details
        const getOrderItemQuery = 'SELECT * FROM OrderItems WHERE order_item_id = $1';
        const getOrderItemResult = await pool.query(getOrderItemQuery, [order_item_id]);

        if (getOrderItemResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Order item not found"
            });
        }

        const { quantity, price_per_unit } = getOrderItemResult.rows[0];
        

        // Retrieve the product details
        const getProductQuery = 'SELECT * FROM Products WHERE product_id = $1';
        const getProductResult = await pool.query(getProductQuery, [product_id]);

        if (getProductResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Product not found"
            });
        }

        const { name, description, brand, price, stock_quantity } = getProductResult.rows[0];

        // Restore stock in the Products table
        const updatedStockQuantity = stock_quantity + quantity;
        const updateProductQuery = `
            UPDATE Products 
            SET name = $1, description = $2, brand = $3, Price = $4, stock_quantity = $5 
            WHERE product_id = $6
        `;
        await pool.query(updateProductQuery, [name, description, brand, price, updatedStockQuantity, product_id]);

       
       const getOrderQuery = 'SELECT * FROM Orders WHERE Owner_ID = $1 AND order_id = $2';
       const getOrderResult = await pool.query(getOrderQuery, [owner_id,order_id]);
       

        const currentTotalAmount = getOrderResult.rows[0].total_amount;
        const newTotalAmount = currentTotalAmount - price_per_unit;

       

        // Update the total_amount in the Orders table
        const updateOrderQuery = `
        UPDATE Orders 
        SET total_amount = $1 
        WHERE order_id = $2 AND Owner_ID = $3
    `;
      await pool.query(updateOrderQuery, [newTotalAmount, order_id, owner_id]);

     

         // Delete the order item
         const deleteOrderItemQuery = 'DELETE FROM OrderItems WHERE order_item_id = $1';
         await pool.query(deleteOrderItemQuery, [order_item_id]);
 

        res.status(200).json({
            status: "Success",
            message: "Order item removed successfully"
        });

    } catch (error) {
        console.error("Error removing order item:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};








module.exports = {
    MakeOrder,
    GetAllOrders ,
    GetOrder,
    DeleteOrder,
    
    SearchByname,
    SearchBycategory,
    SearchBybrand,

    
    AddOrderItem,
    RemoveOrderItem,
    UpdateOrderItem
    
    
}