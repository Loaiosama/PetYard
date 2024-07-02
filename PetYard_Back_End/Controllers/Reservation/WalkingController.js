const pool = require('../../db');
const sendemail = require("../../Utils/email");

const makeWalkingRequest = async (req, res) => {
    const ownerId = req.ID;
    let { Pet_ID, Location, Radius, Start_time, End_time, Final_Price } = req.body;

    try {
        if (!ownerId || !Pet_ID || !Location || !Location.x || !Location.y || !Radius || !Start_time || !End_time || !Final_Price) {
            return res.status(400).json({
                status: "fail",
                message: "Missing information."
            });
        }

        const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
        const ownerRes = await pool.query(ownerQuery, [ownerId]);

        if (ownerRes.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Owner is not in the database."
            });
        }

        // Perform the duplicate check using the pet ID and time range
        const duplicateCheckQuery = `
            SELECT * FROM WalkingRequest 
            WHERE Pet_ID = $1 AND Start_time = $2 AND End_time = $3 AND Owner_ID = $4`;
        const duplicateCheckRes = await pool.query(duplicateCheckQuery, [Pet_ID, Start_time, End_time, ownerId]);

        if (duplicateCheckRes.rows.length > 0) {
            return res.status(400).json({
                status: "fail",
                message: "Duplicate request. A similar request already exists for this owner."
            });
        }

        // Insert into WalkingReservation table
        const insertQuery = `
            INSERT INTO WalkingRequest 
            (Pet_ID, Start_time, End_time, Final_Price, Owner_ID) 
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING *`;
        const insertRes = await pool.query(insertQuery, [Pet_ID, Start_time, End_time, Final_Price, ownerId]);

        // Insert geofence data into Geofence table
        const geofenceQuery = `
            INSERT INTO Geofence (PetOwner_ID, Center_Latitude, Center_Longitude, Radius) 
            VALUES ($1, $2, $3, $4) 
            RETURNING *`;
        const geofenceRes = await pool.query(geofenceQuery, [ownerId, Location.x, Location.y, Radius]);

        res.status(201).json({
            status: "success",
            message: "Request and geofence added successfully.",
            data: {
                reservation: insertRes.rows,
                geofence: geofenceRes.rows
            }
        });

    } catch (e) {
        console.error("Error:", e);
        return res.status(500).json({
            status: "fail",
            message: "Internal server error."
        });
    }
};

const applyForWalkingRequest = async (req, res) => {
    const serviceProviderId = req.ID; // Assuming the ID of the service provider is extracted from the token
    const { reservationId } = req.body;

    try {
        if (!serviceProviderId || !reservationId) {
            return res.status(400).json({
                status: "fail",
                message: "Missing information."
            });
        }

        // Check if the reservation exists, is pending, and is still available
        const requestQuery = `
            SELECT * FROM WalkingRequest 
            WHERE Reserve_ID = $1 
            AND Provider_ID IS NULL 
            AND Status = 'pending'`;
        const requestRes = await pool.query(requestQuery, [reservationId]);

        if (requestRes.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Request not available or status is not pending."
            });
        }

        // Update the reservation to assign the service provider
        const updateQuery = `
            UPDATE WalkingRequest 
            SET Provider_ID = $1 
            WHERE Reserve_ID = $2 
            RETURNING *`;
        const updateRes = await pool.query(updateQuery, [serviceProviderId, reservationId]);

        res.status(200).json({
            status: "success",
            message: "Applied to request successfully.",
            data: updateRes.rows[0]
        });

    } catch (e) {
        console.error("Error:", e);
        return res.status(500).json({
            status: "fail",
            message: "Internal server error."
        });
    }
};

// const GetAllRequset = async (req, res) => { // For provider to call and get all requests made by different owners
//     const providerId = req.ID;
//     try {
//         if (!providerId) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Provider ID not provided."
//             });
//         }

//         const queryProvider = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
//         const resultProvider = await pool.query(queryProvider, [providerId]);

//         if (resultProvider.rows.length === 0) {
//             return res.status(401).json({
//                 status: "Fail",
//                 message: "User doesn't exist."
//             });
//         }

//         const requestQuery = `
//             SELECT wr.*, gf.center_latitude, gf.center_longitude
//             FROM WalkingRequest wr
//             LEFT JOIN Geofence gf ON wr.Owner_ID = gf.PetOwner_ID
//             WHERE wr.Status = $1
//             ORDER BY wr.start_time
//         `;
//         const requestRes = await pool.query(requestQuery, ['Pending']);

//         if (requestRes.rows.length === 0) {
//             return res.status(404).json({
//                 status: "Fail",
//                 message: "Pending walking requests not found"
//             });
//         }

//         res.status(200).json({
//             status: "Success",
//             message: "Pending walking requests retrieved successfully.",
//             data: requestRes.rows
//         });

//     } catch (e) {
//         console.error("Error: ", e);
//         res.status(500).json({
//             status: "Fail",
//             message: "Internal Server Error."
//         });
//     }
// };


const GetPendingWalkingRequests = async (req, res) => { // For owner
    const ownerId = req.ID;

    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide owner ID."
            });
        }

        const query = `
            SELECT wr.Reserve_ID, wr.Pet_ID, wr.Owner_ID, wr.Start_time, wr.End_time, wr.Final_Price, wr.Status,
                   gf.Center_Latitude, gf.Center_Longitude
            FROM WalkingRequest wr
            LEFT JOIN Geofence gf ON wr.Owner_ID = gf.PetOwner_ID
            WHERE wr.Owner_ID = $1 AND wr.Provider_ID IS NULL AND wr.Status = 'Pending'
        `;
        const result = await pool.query(query, [ownerId]);

        res.status(200).json({
            status: "Success",
            reservations: result.rows
        });
    } catch (error) {
        console.error("Error fetching walking requests", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}


const GetWalkingApplications = async(req, res) => {

    const reserveId = req.params.Reserve_ID;
    const ownerId = req.ID;

    try {

        if(!reserveId || !ownerId){
            return res.status(400).json({
                status: "Fail",
                message: "Please provide reservation ID or ownerId."
            })
        }


        const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
        const ownerRes = await pool.query(ownerQuery, [ownerId]);

        if (ownerRes.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner is not in Database"
            });
        }

        const requestQuery = 'SELECT * FROM WalkingRequest WHERE Reserve_ID = $1';
        const requestRes = await pool.query(requestQuery, [reserveId]);

        if (requestRes.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Walking request not found"
            });
        }

        const Query = 'SELECT * FROM WalkingApplication WHERE Reserve_ID = $1';
        const Result = await pool.query(Query, [reserveId]);
      
        res.status(200).json({
            status: "Success",
            message: "Applications retrieved successfuly.",
            data: Result.rows
        })

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        })
    }
}

const getAllPendingRequests = async (req, res) => { // For provider
    const providerId = req.ID;

    try {
        if (!providerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Provider ID not provided."
            });
        }

        const queryProvider = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const resultProvider = await pool.query(queryProvider, [providerId]);

        if (resultProvider.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const reservationQuery = `
            SELECT wr.Reserve_ID, wr.Pet_ID, wr.Owner_ID, wr.Start_time, wr.End_time, wr.Final_Price, wr.Status,
                   gf.Center_Latitude, gf.Center_Longitude
            FROM WalkingRequest wr
            LEFT JOIN Geofence gf ON wr.Owner_ID = gf.PetOwner_ID
            WHERE wr.Status = $1 
            AND wr.Reserve_ID NOT IN (
                SELECT wa.Reserve_ID FROM WalkingApplication wa WHERE wa.Provider_ID = $2
            )
            ORDER BY wr.Start_time`;
        
        const reservationResult = await pool.query(reservationQuery, ['Pending', providerId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No pending walking requests found"
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Pending walking requests retrieved successfully.",
            data: reservationResult.rows
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};


const rejectApplication = async (req, res) => {
    const ownerId = req.ID;
    const { Reserve_ID, Provider_ID } = req.body;

    try {
        if (!Reserve_ID || !ownerId || !Provider_ID) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide reservation ID, owner ID, and provider ID."
            });
        }

        const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
        const ownerRes = await pool.query(ownerQuery, [ownerId]);

        if (ownerRes.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner is not in the database."
            });
        }

        const requestQuery = 'SELECT * FROM WalkingRequest WHERE Reserve_ID = $1 AND Owner_ID = $2';
        const requestRes = await pool.query(requestQuery, [Reserve_ID, ownerId]);

        if (requestRes.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Walking request not found or not authorized."
            });
        }

        const applicationQuery = 'SELECT * FROM WalkingApplication WHERE Reserve_ID = $1 AND Provider_ID = $2';
        const applicationResult = await pool.query(applicationQuery, [Reserve_ID, Provider_ID]);

        if (applicationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Walking application not found or not authorized."
            });
        }

        const updateApplicationQuery = 'UPDATE WalkingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(updateApplicationQuery, ['Rejected', Reserve_ID, Provider_ID]);

        res.status(200).json({
            status: "Success",
            message: "Walking application rejected successfully"
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



module.exports = {
    makeWalkingRequest,
    applyForWalkingRequest,
    // GetAllRequset,
    GetPendingWalkingRequests,
    GetWalkingApplications,
    getAllPendingRequests,
    rejectApplication
}