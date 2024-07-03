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
                status: "fail",
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

        // Check if the provider has already applied for this reservation
        const existingApplicationQuery = `
            SELECT * FROM WalkingApplication 
            WHERE Provider_ID = $1 
            AND Reserve_ID = $2`;
        const existingApplicationRes = await pool.query(existingApplicationQuery, [serviceProviderId, reservationId]);

        if (existingApplicationRes.rows.length > 0) {
            return res.status(400).json({
                status: "fail",
                message: "You have already applied for this reservation."
            });
        }



        const currentTime = Date.now();
        expirationTime = currentTime+ (6 * 60 * 60 * 1000);

        // Insert data into the WalkingApplication table
        const insertApplicationQuery = `
            INSERT INTO WalkingApplication (Provider_ID, Reserve_ID,expirationTime) 
            VALUES ($1, $2,$3)
            RETURNING *`;
        const insertApplicationRes = await pool.query(insertApplicationQuery, [serviceProviderId, reservationId,expirationTime]);

        // Sending email notification to the owner
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [requestRes.rows[0].owner_id]);

        const petQuery = 'SELECT * FROM Pet WHERE Pet_Id = $1';
        const petResult = await pool.query(petQuery, [requestRes.rows[0].pet_id]);

        const message = `
            🐾 Pet Walking Application Received! 🐾

            Dear ${ownerResult.rows[0].first_name},

            We are thrilled to inform you that a service provider has applied for your pet walking request! Here are the details of the application:

            - **Reservation ID:** ${reservationId}
            - **Service Provider Name:** ${providerResult.rows[0].username}
            - **Start Time:** ${requestRes.rows[0].start_time}
            - **End Time:** ${requestRes.rows[0].end_time}
            - **Pet Name:** ${petResult.rows[0].name}

            Please review the application at your earliest convenience. If you have any questions or need further assistance, feel free to contact us.

            Thank you for choosing PetYard. We are committed to providing the best care for your pet.

            Best regards,
            The PetYard Team
        `;

        await sendemail.sendemail({
            email: ownerResult.rows[0].email,
            subject: 'New Pet Walking Application 🐾',
            message
        });

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

const GetAllRequset = async (req, res) => { 
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

        const requestQuery = `
            SELECT DISTINCT wr.*, gf.center_latitude, gf.center_longitude, p.Name AS pet_name, p.Image AS pet_image
            FROM WalkingRequest wr
            LEFT JOIN Geofence gf ON wr.Owner_ID = gf.PetOwner_ID
            LEFT JOIN Pet p ON wr.Pet_ID = p.Pet_Id
            WHERE wr.Status = $1
            ORDER BY wr.start_time
        `;
        const requestRes = await pool.query(requestQuery, ['Pending']);

        if (requestRes.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pending walking requests not found"
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Pending walking requests retrieved successfully.",
            data: requestRes.rows
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        });
    }
};



const GetPendingWalkingRequests = async (req, res) => { // For owner
    const ownerId = req.ID;

    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide owner ID."
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
        const requestQuery = `
        SELECT DISTINCT wr.*, gf.center_latitude, gf.center_longitude, p.Name AS pet_name, p.Image AS pet_image
        FROM WalkingRequest wr
        LEFT JOIN Geofence gf ON wr.Owner_ID = gf.PetOwner_ID
        LEFT JOIN Pet p ON wr.Pet_ID = p.Pet_Id
        WHERE wr.Status = $1
        ORDER BY wr.start_time
        `;
        const requestRes = await pool.query(requestQuery, ['Pending']);

        if (requestRes.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No pending walking requests found"
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Pending walking requests retrieved successfully.",
            data: requestRes.rows
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

        const ownerQuery = "SELECT * FROM PetOwner WHERE Owner_Id = $1";
        const ownerRes = await pool.query(ownerQuery, [ownerId]);

        if (ownerRes.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner is not in the database."
            });
        }

        const requestQuery = 'SELECT * FROM WalkingRequest WHERE Reserve_ID = $1 AND Owner_Id = $2';
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

        // Fetch necessary details for the email notification
        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [Provider_ID]);

        const petQuery = `
         SELECT * FROM Pet WHERE Pet_Id=$1
        `;
        const petResult = await pool.query(petQuery, [requestRes.rows[0].pet_id]);

        const message = `
            🐾 Pet Walking Application Rejected 🐾

            Dear ${providerResult.rows[0].Username},

            We regret to inform you that your application for the pet walking request has been rejected by the pet owner. Here are the details of the request:

            - **Reservation ID:** ${Reserve_ID}
            - **Pet Name:** ${petResult.rows[0].name}
            - **Start Time:** ${requestRes.rows[0].start_time}
            - **End Time:** ${requestRes.rows[0].end_time}

            If you have any questions or need further assistance, please feel free to contact us.

            Best regards,
            The PetYard Team
        `;

     
         await sendemail.sendemail({
           email: providerResult.rows[0].email,
            subject: 'Pet Walking Application Rejected 🐾',
            message
         });

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



const acceptApplication = async (req, res) => {
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

        // Check if any application for this reservation is already accepted
        const checkAcceptedQuery = 'SELECT * FROM WalkingApplication WHERE Reserve_ID = $1 AND Application_Status = $2';
        const checkAcceptedResult = await pool.query(checkAcceptedQuery, [Reserve_ID, 'Accepted']);

        if (checkAcceptedResult.rows.length > 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Another application has already been accepted for this reservation."
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

           // Update the WalkingRequest to set the status to 'Accepted' and the provider
        const updateRequestQuery = 'UPDATE WalkingRequest SET Status = $1, Provider_ID = $2 WHERE Reserve_ID = $3';
       await pool.query(updateRequestQuery, ['Accepted', Provider_ID, Reserve_ID]);
   
        const updateApplicationQuery = 'UPDATE WalkingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(updateApplicationQuery, ['Accepted', Reserve_ID, Provider_ID]);



        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [Provider_ID]);

        const petQuery = 'SELECT * FROM Pet WHERE Pet_Id = $1';
        const petResult = await pool.query(petQuery, [requestRes.rows[0].pet_id]);

        const message = `
            🐾 Pet Walking Application Accepted 🐾

            Dear ${providerResult.rows[0].username},

            Congratulations! Your application for the pet walking request has been accepted by the pet owner. Here are the details of the request:

            - **Reservation ID:** ${Reserve_ID}
            - **Pet Name:** ${petResult.rows[0].name}
            - **Start Time:** ${requestRes.rows[0].start_time}
            - **End Time:** ${requestRes.rows[0].end_time}

            Please prepare for the scheduled walk accordingly. If you have any questions or need further assistance, please feel free to contact us.

            Best regards,
            The PetYard Team
        `;

        // Uncomment and replace with your actual email sending function
         await sendemail.sendemail({
             email: providerResult.rows[0].email,
             subject: 'Pet Walking Application Accepted 🐾',
             message
         });

        res.status(200).json({
            status: "Success",
            message: "Walking application accepted successfully"
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



const getALLAcceptedRequest = async (req, res) => {
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

        const acceptedRequestsQuery = `
            SELECT 
                wr.Reserve_ID, 
                wr.Pet_ID, 
                p.Name AS Pet_Name, 
                p.Image AS Pet_Image,
                wr.Owner_ID, 
                po.First_name || ' ' || po.Last_name AS Owner_Name, 
                wr.Start_time, 
                wr.End_time, 
                wr.Final_Price, 
                wr.Provider_ID, 
                sp.UserName AS Provider_Name
            FROM 
                WalkingRequest wr
            JOIN 
                Pet p ON wr.Pet_ID = p.Pet_Id
            JOIN 
                Petowner po ON wr.Owner_ID = po.Owner_Id
            JOIN 
                ServiceProvider sp ON wr.Provider_ID = sp.Provider_Id
            WHERE 
                wr.Status = 'Accepted' AND wr.Provider_ID = $1;
        `;

        const acceptedRequestsResult = await pool.query(acceptedRequestsQuery, [providerId]);

        if (acceptedRequestsResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No accepted requests found for this provider."
            });
        }

        res.status(200).json({
            status: "Success",
            data: acceptedRequestsResult.rows
        });
    } catch (error) {
        console.error("Error: ", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};







module.exports = {
    makeWalkingRequest,
    applyForWalkingRequest,
    GetAllRequset,
    GetPendingWalkingRequests,
    GetWalkingApplications,
    getAllPendingRequests,
    rejectApplication,
    acceptApplication,
    getALLAcceptedRequest,
   
}