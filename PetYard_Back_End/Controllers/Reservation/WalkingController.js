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

        // Perform the overlapping check using the pet ID and time range
        const overlapCheckQuery = `
            SELECT * FROM WalkingRequest 
            WHERE Pet_ID = $1 AND Owner_ID = $2 AND (
                ($3 < End_time AND $4 > Start_time) -- New request overlaps with existing request
            )
        `;
        const overlapCheckRes = await pool.query(overlapCheckQuery, [Pet_ID, ownerId, Start_time, End_time]);

        if (overlapCheckRes.rows.length > 0) {
            return res.status(400).json({
                status: "fail",
                message: "Overlapping request. A similar request already exists for this owner in the specified time range."
            });
        }

        // Insert into WalkingRequest table
        const insertQuery = `
            INSERT INTO WalkingRequest 
            (Pet_ID, Start_time, End_time, Final_Price, Owner_ID) 
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING *
        `;
        const insertRes = await pool.query(insertQuery, [Pet_ID, Start_time, End_time, Final_Price, ownerId]);

        // Insert geofence data into Geofence table
        const geofenceQuery = `
            INSERT INTO Geofence (PetOwner_ID, Center_Latitude, Center_Longitude, Radius) 
            VALUES ($1, $2, $3, $4) 
            RETURNING *
        `;
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

        const providerQuery = "SELECT * FROM ServiceProvider WHERE Provider_Id = $1";
        const providerResult = await pool.query(providerQuery, [serviceProviderId]);

        if (providerResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Provider is not registered in the database."
            });
        }



        // Check if the reservation exists, is pending, and is still available
        const requestQuery = `
            SELECT * FROM WalkingRequest 
            WHERE Reserve_ID = $1 
            AND Provider_ID IS NULL 
            AND Status = 'Pending'`;
        const requestRes = await pool.query(requestQuery, [reservationId]);

        if (requestRes.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Request not available or status is not pending."
            });
        }




        // Insert data into the WalkingApplication table
        const insertApplicationQuery = `
            INSERT INTO WalkingApplication (Provider_ID, Reserve_ID) 
            VALUES ($1, $2)
            RETURNING *`;
        const insertApplicationRes = await pool.query(insertApplicationQuery, [serviceProviderId, reservationId]);
/*
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);
        const petQuery = 'SELECT * FROM Pet WHERE Pet_Id = $1';
        const petResult = await pool.query(petQuery, [Pet_ID]);

        const message = `
            🐾 Pet Walking Application Received! 🐾

            Dear ${ownerResult.rows[0].First_name},

            We are thrilled to inform you that a service provider has applied for your pet walking request! Here are the details of the application:

            - **Reservation ID:** ${reservationId}
            - **Service Provider Name:** ${providerResult.rows[0].username}
            - **Start Time:** ${Start_time}
            - **End Time:** ${End_time}
            - **Pet Name:** ${petResult.rows[0].Pet_name}

            Please review the application at your earliest convenience. If you have any questions or need further assistance, feel free to contact us.

            Thank you for choosing PetYard. We are committed to providing the best care for your pet.

            Best regards,
            The PetYard Team
        `;

        await sendemail.sendemail({
            email: ownerResult.rows[0].email,
            subject: 'New Pet Walking Application 🐾',
            message
        });*/


        res.status(200).json({
            status: "success",
            message: "Applied to request successfully.",
            data: {
                application: insertApplicationRes.rows[0]
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
                   MAX(gf.Center_Latitude) AS Center_Latitude, MAX(gf.Center_Longitude) AS Center_Longitude
            FROM WalkingRequest wr
            LEFT JOIN Geofence gf ON wr.Owner_ID = gf.PetOwner_ID
            WHERE wr.Owner_ID = $1 AND wr.Provider_ID IS NULL AND wr.Status = 'Pending'
            GROUP BY wr.Reserve_ID, wr.Pet_ID, wr.Owner_ID, wr.Start_time, wr.End_time, wr.Final_Price, wr.Status
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
            SELECT DISTINCT ON (wr.Reserve_ID) 
                   wr.Reserve_ID, wr.Pet_ID, wr.Owner_ID, wr.Start_time, wr.End_time, wr.Final_Price, wr.Status,
                   gf.Center_Latitude, gf.Center_Longitude
            FROM WalkingRequest wr
            LEFT JOIN Geofence gf ON wr.Owner_ID = gf.PetOwner_ID
            WHERE wr.Status = $1 
            AND wr.Reserve_ID NOT IN (
                SELECT wa.Reserve_ID FROM WalkingApplication wa WHERE wa.Provider_ID = $2
            )
            ORDER BY wr.Reserve_ID, wr.Start_time`;

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