const { query } = require('express');
const pool = require('../../db');
const sendemail = require("./../../Utils/email");
const stripe = require('stripe')('sk_test_51PTJooRs2c4dEAvUNiMETK8G8UrylXjjUX0hzy1kCbX8lBELXYfI2Uuyg9yEAtcgcUkd4uIpILhrjGUSxYgpWdBc00aONnihy4');

const AddShipping = async (req, res) => {
    const id = req.ID;
    const { order_id } = req.params;
    const { type, location, city, state, postal_code, country, phone, address } = req.body;

    try {
        if (!id || !order_id || !type || !location || !city || !state || !postal_code || !country || !phone || !address) {
            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }

        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [id]);
        const email = resultPetOwner.rows[0].email;
        const name = resultPetOwner.rows[0].first_name;

        if (resultPetOwner.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pet owner not found"
            });
        }

        const GetOrder = await pool.query('SELECT * FROM Orders WHERE Owner_ID = $1 AND order_id = $2', [id, order_id]);
        const total_amount=GetOrder.rows[0].total_amount;
        const getitem = await pool.query('SELECT * FROM OrderItems WHERE order_id = $1', [order_id]);

        if (GetOrder.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Not Found This Order"
            });
        }

        // Check if the order has already been added to the Shipping table
        const checkShipping = await pool.query('SELECT * FROM Shipping WHERE order_id = $1', [order_id]);

        if (checkShipping.rows.length > 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Shipping already exists for this order"
            });
        }

        // Handle Cash payment
        if (type === 'Cash') {
            const locationString = `(${location.x}, ${location.y})`;

            const insertQuery = 'INSERT INTO Shipping (type, order_id, location, city, state, postal_code, country, phone, address) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *';
            const Result = await pool.query(insertQuery, [type, order_id, locationString, city, state, postal_code, country, phone, address]);

            const message = `
                🎉 Your Shipping is Confirmed! 🎉

                Dear ${name},

                We're excited to inform you that your shipping is all set! Your order will arrive within one day.

                Thank you for choosing our service. We hope you and your pet have a wonderful experience!

                Best regards,
                The PetYard Team
            `;

            await sendemail.sendemail({
                email: email,
                subject: 'Your Shipping Confirmation 😄',
                message
            });

            return res.status(201).json({ message: "Shipping added successfully", Shipping: Result.rows[0], order: GetOrder.rows[0], Item: getitem.rows });
        }

        // Handle Online payment
        else if (type === 'Online') {
            // Create a Stripe session for payment
            const session = await stripe.checkout.sessions.create({
                payment_method_types: ['card'],
                line_items: [{
                    price_data: {
                        currency: 'usd',
                        product_data: {
                            name: 'Shipping Service', 
                        },
                        unit_amount: total_amount, 
                    },
                    quantity: 1,
                }],
                mode: 'payment',
                success_url: 'http://localhost:3000/complete',
                cancel_url: 'http://localhost:3000/cancel',
            });

            // Save shipping details to database
            const locationString = `(${location.x}, ${location.y})`;
            const insertQuery = 'INSERT INTO Shipping (type, order_id, location, city, state, postal_code, country, phone, address,paid) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9,$10) RETURNING *';
            const Result = await pool.query(insertQuery, [type, order_id, locationString, city, state, postal_code, country, phone, address,"True"]);

            // Send confirmation email
            const message = `
                🎉 Your Shipping is Confirmed! 🎉

                Dear ${name},

                We're excited to inform you that your shipping is all set! Your order will arrive within one day.

                Thank you for choosing our service. We hope you and your pet have a wonderful experience!

                Best regards,
                The PetYard Team
            `;

            await sendemail.sendemail({
                email: email,
                subject: 'Your Shipping Confirmation 😄',
                message
            });
            

            return res.status(201).json({ message: "Shipping added successfully", Shipping: Result.rows[0], order: GetOrder.rows[0], Item: getitem.rows, sessionId: session.id });
        }

        // Invalid type
        else {
            return res.status(400).json({
                status: "Fail",
                message: "Invalid payment type"
            });
        }

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};


const RemoveShipping=async(req,res)=>{
    const id=req.ID;
    const {Shipping_id}=req.params;
    try {
        if(!id || !Shipping_id){
            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }
        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const checkShipping = await pool.query('SELECT * FROM Shipping WHERE shipping_id = $1', [Shipping_id]);

        if (checkShipping.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Shipping not found"
            });
        }
        const Delete = await pool.query('DELETE FROM Shipping WHERE shipping_id = $1', [Shipping_id]);

        res.status(200).json({
            status: "Success",
            message: "Shipping Deleted successfully"
        });
        
    } catch (error) {

        console.error("Error :", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
        
    }

};


const received =async (req,res)=>{
    const id=req.ID;
    const {Shipping_id}=req.params;
   
    try {

        if(!id || !Shipping_id ){

            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }
        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        
        const checkShipping = await pool.query('SELECT * FROM Shipping WHERE shipping_id = $1', [Shipping_id]);
       


        if (checkShipping.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Shipping not found"
            });
        }
     
        const order_id= checkShipping.rows[0].order_id;


        const GetOrder = await pool.query('SELECT * FROM Orders WHERE order_id = $1', [ order_id]);
        const Owner_ID=GetOrder.rows[0].owner_id;

        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [Owner_ID]);
        const email = resultPetOwner.rows[0].email;
        const name = resultPetOwner.rows[0].first_name;

        const message = `
            📦 Your Order is on the Way! 📦

            Hi ${name},

            We're thrilled to let you know that your shipping has been confirmed and your order is now on its way! You can expect it to arrive within one day.

            Thank you for choosing PetYard. We hope your pet enjoys their new goodies!

            If you have any questions or need further assistance, feel free to reach out to our support team.

            Best wishes,
            The PetYard Team
        `;

        await sendemail.sendemail({
            email: email,
            subject: 'Your Shipping Confirmation 🚚',
            message
        });


    return res.status(200).json({ message: "Send Email successfully" });

       /* const updateQuery = 'UPDATE Pet SET  Name=$1,Gender=$2,Breed=$3,Date_of_birth=$4,Adoption_Date=$5,Weight=$6,Image=$7,Bio=$8 WHERE Pet_Id=$9 AND owner_id=$10';
        const UpdatePet =await pool.query(updateQuery ,[Name,Gender,Breed,Date_of_birth,Adoption_Date,Weight,Image,Bio,Pet_Id,owner_id]);

        res.status(200).json({
            status: "Success",
            message: " update successfully"
        }); */


        




        
    } catch (error) {


        console.error("Error :", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
        
        
    }

   

};

const updateStatus = async (req,res)=>{
    const id=req.ID;
    const {Shipping_id}=req.params;
    const {status}=req.body;
    try {

      if(!id || !Shipping_id  || !status){

            return res.status(400).json({
                status: "Fail",
                message: "Required fields are missing"
            });
        }
        const queryPetOwner = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const resultPetOwner = await pool.query(queryPetOwner, [id]);
        if (resultPetOwner.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }
        const checkShipping = await pool.query('SELECT * FROM Shipping WHERE shipping_id = $1', [Shipping_id]);
       


        if (checkShipping.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Shipping not found"
            });
        }

     const updateQuery = 'UPDATE Shipping SET  status=$1 WHERE Shipping_id=$2';
     const UpdatePet =await pool.query(updateQuery ,[status,Shipping_id]);

  
     return res.status(200).json({ message: "Status Update successfully" });
        
    } catch (error) {
        console.error("Error :", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
        
    }

};

module.exports = {
    AddShipping,
    RemoveShipping,
    received,
    updateStatus

};
