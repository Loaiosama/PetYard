const pool = require('../../db');
const sendemail = require("../../Utils/email");

const makeRequest = async(req, res) =>{
    const ownerId = req.ID;
    let {Pet_ID, Location, Start_time, End_time, Final_Price} = req.body;
    try {

        // if(!ownerId || !Pet_ID || !Location || !Start_time || !End_time || !Final_Price){
        //     return res.status(400).json({
        //         status: "fail",
        //         message: "Missing information."
        //     });
        // }

        const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
        const ownerRes = await pool.query(ownerQuery, [ownerId]);

        if(ownerRes.rows.length === 0){
            return res.status(400).json({
                status: "Fail",
                message: "Owner is not in Database"
            });
        }

        const insertQuery = "INSERT INTO SittingReservation (Pet_ID, Start_time, End_time, Final_Price, Owner_ID) VALUES ($1, $2, $3, $4, $5) RETURNING *"
        const insertRes = await pool.query(insertQuery, [Pet_ID, Start_time, End_time, Final_Price, ownerId])
        
        res.status(201).json({
            status: "success",
            message: "Request added successfuly.",
            data: insertRes.rows
        })
        
    } catch (e) {
        console.error("Error:", e);
        return res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
}

const applySittingRequest = async(req, res) =>{
    const providerId = req.ID;
    let {Reserve_ID} = req.body;
    try {

        if(!providerId){
            return res.status(400).json({
                status: "Fail",
                message: "ID not provided."
            })
        }

        const query = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1';
        const result = await pool.query(query, [Reserve_ID]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found"
            });
        }

        const applyQuery = "INSERT INTO SittingApplication (Reserve_ID, Provider_ID) VALUES ($1, $2) RETURNING *"
        const applyRes = await pool.query(applyQuery, [Reserve_ID, providerId]);

        res.status(201).json({
            status: "Success",
            message: "Application created successfuly.",
            data: applyRes.rows[0]
        })
        
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        })
    }
}

const GetSittingReservations = async (req, res) => {
    const ownerId = req.ID;

    try {
        const query = 'SELECT * FROM SittingReservation WHERE Owner_ID = $1';
        const result = await pool.query(query, [ownerId]);

        res.status(200).json({
            status: "Success",
            reservations: result.rows
        });
    } catch (error) {
        console.error("Error fetching sitting reservations", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}


const getSittingApplications = async(req, res) => {

    const reserveId = req.params.Reserve_ID;

    try {

        if(!reserveId){
            return res.status(400).json({
                status: "Fail",
                message: "Please provide reservation ID."
            })
        }

        const appQuery = "SELECT * FROM SittingApplication WHERE Reserve_ID = $1";
        const result = await pool.query(appQuery, [reserveId]);

        res.status(200).json({
            status: "Success",
            message: "Applications retrieved successfuly.",
            data: result.rows
        })


        
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        })
    }


}


const acceptSittingApplication = async (req, res) => {
    const ownerId = req.ID;
    const { Reserve_ID, Provider_ID } = req.body;

    try {
        const query = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1 AND Owner_ID = $2';
        const result = await pool.query(query, [Reserve_ID, ownerId]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found or not authorized"
            });
        }

        const updateQuery = 'UPDATE SittingReservation SET Provider_ID = $1, Status = $2 WHERE Reserve_ID = $3 RETURNING *';
        const updateResult = await pool.query(updateQuery, [Provider_ID, 'Accepted', Reserve_ID]);

        const applicationQuery = 'UPDATE SittingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(applicationQuery, ['Accepted', Reserve_ID, Provider_ID]);

        res.status(200).json({
            status: "Success",
            message: "Sitting reservation confirmed successfully",
            reservation: updateResult.rows[0]
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}





module.exports = {
    makeRequest,
    applySittingRequest,
    GetSittingReservations,
    getSittingApplications,
    acceptSittingApplication
};