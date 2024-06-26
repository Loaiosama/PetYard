const pool = require('../../db');
const sendemail = require("../../Utils/email");
const moment = require('moment-timezone');

const createGroomingSlots = async (req, res) => {
    const providerId = req.ID;
    let { Start_time, End_time, Price, Slot_length } = req.body;

    try {
        if (!providerId || !Start_time || !End_time || !Price || !Slot_length) {
            return res.status(400).json({
                status: "Fail",
                message: "Missing information."
            });
        }

        const startTime = new Date(Start_time);
        const endTime = new Date(End_time);

        const checkOverlapQuery = `
            SELECT * FROM GroomingServiceSlots
            WHERE Provider_ID = $1
            AND (
                (Start_time < $2::timestamp AND End_time > $2::timestamp)
                OR
                (Start_time < $3::timestamp AND End_time > $3::timestamp)
                OR
                (Start_time >= $2::timestamp AND End_time <= $3::timestamp)
            )
        `;
        const overlapResult = await pool.query(checkOverlapQuery, [providerId, startTime.toISOString(), endTime.toISOString()]);

        if (overlapResult.rows.length > 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Overlapping slots found. Please choose a different time range."
            });
        }

        const slots = [];
        let currentStartTime = new Date(startTime);

        while (currentStartTime < endTime) {
            let currentEndTime = new Date(currentStartTime);
            currentEndTime.setMinutes(currentStartTime.getMinutes() + Slot_length);

            if (currentEndTime > endTime) {
                break;
            }

            const slotsQuery = `INSERT INTO GroomingServiceSlots (Provider_ID, Start_time, End_time, Price) VALUES ($1, $2, $3, $4) RETURNING *`;
            const queryRes = await pool.query(slotsQuery, [providerId, currentStartTime.toISOString(), currentEndTime.toISOString(), Price]);

            const slotData = queryRes.rows[0];

            // Adjusting the times for display
            const adjustedSlot = {
                slot_id: slotData.slot_id,
                provider_id: slotData.provider_id,
                start_time: new Date(slotData.start_time).toISOString(), // Assuming slotData.start_time is in UTC
                end_time: new Date(slotData.end_time).toISOString(),     // Assuming slotData.end_time is in UTC
                price: slotData.price,
                grooming_type: null
            };

            // Add +3 hours adjustment
            adjustedSlot.start_time = new Date(adjustedSlot.start_time);
            adjustedSlot.start_time.setHours(adjustedSlot.start_time.getHours() + 3);

            adjustedSlot.end_time = new Date(adjustedSlot.end_time);
            adjustedSlot.end_time.setHours(adjustedSlot.end_time.getHours() + 3);

            slots.push(adjustedSlot);

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
        });
    }
};







const setGroomingTypesForProvider = async (req, res) => {
    const providerId = req.ID;
    const { groomingType } = req.body;

    try {
        if (!providerId || !groomingType) {
            return res.status(400).json({
                status: "Fail",
                message: "Missing or invalid information."
            });
        }

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(Query, [providerId]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const checkQuery = 'SELECT * FROM ProviderGroomingTypes WHERE Provider_ID = $1 AND Grooming_Type = $2';
        const checkResult = await pool.query(checkQuery, [providerId, groomingType]);

        if (checkResult.rows.length > 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Grooming type already set for this provider."
            });
        }

        await pool.query('INSERT INTO ProviderGroomingTypes (Provider_ID, Grooming_Type) VALUES ($1, $2)', [providerId, groomingType]);

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
        if (!providerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Missing or invalid information."
            });
        }

        const query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(query, [providerId]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const result = await pool.query('SELECT Grooming_Type FROM ProviderGroomingTypes WHERE Provider_ID = $1', [providerId]);

        res.status(200).json({
            status: "Success",
            groomingTypes: result.rows
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Failed",
            message: "Internal server error."
        });
    }
};




const getGroomingSlots = async (req, res) => {
    const providerId = req.ID;

    try {
        if (!providerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Provider ID is missing."
            });
        }

        const providerQuery = "SELECT * FROM ServiceProvider WHERE Provider_Id = $1";
        const providerRes = await pool.query(providerQuery, [providerId]);

        if (providerRes.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Provider is not registered in the database."
            });
        }

        const slotsQuery = "SELECT * FROM GroomingServiceSlots WHERE Provider_ID = $1";
        const slotsRes = await pool.query(slotsQuery, [providerId]);

        if (slotsRes.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No slots created."
            });
        }

        // Adjusting the times for display (+3 hours)
        const slots = slotsRes.rows.map(slot => ({
            slot_id: slot.slot_id,
            provider_id: slot.provider_id,
            start_time: moment.utc(slot.start_time).add(3, 'hours').toISOString(), // Adding 3 hours to start_time
            end_time: moment.utc(slot.end_time).add(3, 'hours').toISOString(),     // Adding 3 hours to end_time
            price: slot.price,
            grooming_type: slot.grooming_type
        }));

        res.status(200).json({
            status: "Success",
            message: "Slots retrieved successfully.",
            data: slots
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};



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
            INSERT INTO GroomingReservation (Slot_ID, Pet_ID, Owner_ID, Start_time, End_time, Final_Price, Grooming_Type)
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