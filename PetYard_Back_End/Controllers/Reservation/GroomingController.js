const pool = require('../../db');
const sendemail = require("../../Utils/email");

const createGroomingSlots = async(req, res) =>{
    const providerId = req.ID;
    let{Start_time, End_time, Price, Slot_length} = req.body;

    try {

        if(!providerId || !Start_time || !End_time || !Price || !Slot_length){

            return res.status(400).json({
                status: "Fail",
                message: "Missing information."
            })
        }

        const startTime = new Date(Start_time);
        const endTime = new Date(End_time);

        const slots = [];

        let currentStartTime = new Date(startTime);

        while(currentStartTime < endTime){

            let currentEndTime = new Date(currentStartTime);

            currentEndTime.setMinutes(currentStartTime.getMinutes() + Slot_length);

            if (currentEndTime > endTime) {
                break;
            }

            const slotsQuery = `INSERT INTO GroomingServiceSlots (Provider_ID, Start_time, End_time, Price) VALUES ($1, $2, $3, $4) RETURNING *`;

            const queryRes = await pool.query(slotsQuery, [providerId, currentStartTime, currentEndTime, Price]);

            slots.push(queryRes.rows[0]);

            currentStartTime = new Date(currentEndTime);
        }

        res.status(201).json({
            status: "Success",
            message: "Grooming slots created successfully.",
            data: slots
        });

            

        
        
    } catch (e) {
        console.error("Error: ", e);

        res.status(500).json({
            status: "Failed",
            message: "Internal server error."
        })
    }
}

const setGroomingTypesForProvider = async (req, res) => {
    const providerId = req.ID;
    const { groomingTypes } = req.body;

    if (!providerId || !groomingTypes || !Array.isArray(groomingTypes)) {
        return res.status(400).json({
            status: "Fail",
            message: "Missing or invalid information."
        });
    }

    try {

        await pool.query('DELETE FROM ProviderGroomingTypes WHERE Provider_ID = $1', [providerId]);

        for (let type of groomingTypes) {
            await pool.query('INSERT INTO ProviderGroomingTypes (Provider_ID, GroomingType) VALUES ($1, $2)', [providerId, type]);
        }

        res.status(201).json({
            status: "Success",
            message: "Grooming types set successfully."
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Failed",
            message: "Internal server error."
        });
    }
};

const getGroomingTypesForProvider = async (req, res) => {
    const providerId = req.ID;

    try {
        const result = await pool.query('SELECT GroomingType FROM ProviderGroomingTypes WHERE Provider_ID = $1', [providerId]);
        res.status(200).json({
            status: "Success",
            groomingTypes: result.rows.map(row => row.groomingtype)
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Failed",
            message: "Internal server error."
        });
    }
};




const getGroomingSlots = async(req, res) =>{

    const providerId = req.ID;

    try {

        if(!providerId){
            return res.status(400).json({
                status: "Fail",
                message: "Provider ID is missing."
            })
        }
    
        const providerQuery = "SELECT FROM ServiceProvider WHERE Provider_Id = $1";
        const providerRes = await pool.query(providerQuery, providerId);
    
        if(providerRes.rows.length === 0){
            return res.status(400).json({
                status: "Fail",
                message: "Provider is not registered in the database."
            })
        }

        const slotsQuery = "SELECT * FROM GroomingServiceSlots WHERE Provider_ID = $1";
        const slotsRes = await pool.query(slotsQuery, providerId);

        if(slotsRes.rows.length === 0 ){
            return res.status(404).json({
                status: "Fail",
                message: "No slots created."
            })
        }

        res.status(200).json({
            status: "Success",
            message: "Slots retrieved successfuly.",
            data: slotsRes.rows
        })
        
    } catch (e) {

        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        })
        
    }
    
}


const bookGroomingSlot = async (req, res) => {
    const ownerId = req.ID;  
    const { slot_id, pet_id, final_price, grooming_type } = req.body;

    try {
        if (!ownerId || !slot_id || !pet_id || !final_price || !grooming_type) {
            return res.status(400).json({
                status: "fail",
                message: "Missing information."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Owner not found."
            });
        }

        const slotQuery = 'SELECT * FROM GroomingServiceSlots WHERE Slot_ID = $1';
        const slotResult = await pool.query(slotQuery, [slot_id]);

        if (slotResult.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Grooming slot not found."
            });
        }

        const slot = slotResult.rows[0];

        const insertQuery = `
            INSERT INTO GroomingReservation (Slot_ID, Pet_ID, Owner_ID, Start_time, End_time, Final_Price, Type)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING *`;

        const insertResult = await pool.query(insertQuery, [slot_id, pet_id, ownerId, slot.start_time, slot.end_time, final_price, grooming_type]);

        res.status(201).json({
            status: "success",
            message: "Grooming slot booked successfully.",
            data: insertResult.rows[0]
        });

    } catch (e) {
        console.error("Error:", e);
        return res.status(500).json({
            status: "fail",
            message: "Internal server error."
        });
    }
};

const getGroomingReservations = async (req, res) => { //Grooming reservations made by a pet owner
    const ownerId = req.ID;
    try {
        const query = 'SELECT * FROM GroomingReservation WHERE Owner_ID = $1 ORDER BY Start_time';
        const result = await pool.query(query, [ownerId]);

        res.status(200).json({
            status: "success",
            message: "Grooming reservations retrieved successfully.",
            data: result.rows
        });
    } catch (error) {
        console.error("Error fetching grooming reservations", error);
        res.status(500).json({
            status: "fail",
            message: "Internal server error"
        });
    }
};


module.exports = {
    createGroomingSlots,
    getGroomingSlots,
    bookGroomingSlot,
    setGroomingTypesForProvider,
    getGroomingTypesForProvider,
    getGroomingReservations
}