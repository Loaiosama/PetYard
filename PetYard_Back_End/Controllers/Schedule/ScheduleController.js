const pool = require('../../db');
const { query } = require('express');


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
        const addedService = await client.query(addslotQuery, [Service_ID, provider_id,Price,Start_time,End_time]);
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



module.exports = {  
    CreateSlot,
    GetAllSlots,
    GetSlot,
    DeleteSlot,
    UpdateSlot
    
};