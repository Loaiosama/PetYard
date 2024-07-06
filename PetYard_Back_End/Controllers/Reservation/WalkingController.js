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

        const startTime = new Date(Start_time);
        const endTime = new Date(End_time);
        const currentTime = new Date();

        // Check if the start time is in the past
        if (startTime < currentTime) {
            return res.status(400).json({
                status: "fail",
                message: "Start time has already passed. Please choose a future start time."
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
        const overlapCheckRes = await pool.query(overlapCheckQuery, [Pet_ID, ownerId, startTime.toISOString(), endTime.toISOString()]);

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
        const insertRes = await pool.query(insertQuery, [Pet_ID, startTime.toISOString(), endTime.toISOString(), Final_Price, ownerId]);

        // Insert geofence data into Geofence table using the returned Reserve_ID
        const reserveId = insertRes.rows[0].reserve_id;
        const geofenceQuery = `
            INSERT INTO Geofence (Reserve_ID, Center_Latitude, Center_Longitude, Radius) 
            VALUES ($1, $2, $3, $4) 
            RETURNING *
        `;
        const geofenceRes = await pool.query(geofenceQuery, [reserveId, Location.x, Location.y, Radius]);

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

const GetAllRequest = async (req, res) => {
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
            LEFT JOIN Geofence gf ON wr.Reserve_ID = gf.Reserve_ID
            LEFT JOIN Pet p ON wr.Pet_ID = p.Pet_Id
            WHERE wr.Status = $1
            ORDER BY wr.start_time
        `;
        const requestRes = await pool.query(requestQuery, ['Pending']);

        if (requestRes.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pending walking requests not found."
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




const GetPendingWalkingRequests = async (req, res) => {
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
                status: "Fail",
                message: "Owner is not in the database."
            });
        }

        const query = `
            SELECT 
                wr.Reserve_ID, 
                wr.Pet_ID, 
                p.Name AS Name, 
                p.Image AS Image,
                wr.Owner_ID, 
                wr.Start_time, 
                wr.End_time, 
                wr.Final_Price, 
                wr.Status,
                MAX(gf.Center_Latitude) AS Center_Latitude, 
                MAX(gf.Center_Longitude) AS Center_Longitude
            FROM 
                WalkingRequest wr
            LEFT JOIN 
                Geofence gf ON wr.Reserve_ID = gf.Reserve_ID
            JOIN 
                Pet p ON wr.Pet_ID = p.Pet_Id
            WHERE 
                wr.Owner_ID = $1 
                AND wr.Provider_ID IS NULL 
                AND wr.Status = 'Pending'
            GROUP BY 
                wr.Reserve_ID, 
                wr.Pet_ID, 
                p.Name, 
                p.Image, 
                wr.Owner_ID, 
                wr.Start_time, 
                wr.End_time, 
                wr.Final_Price, 
                wr.Status
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
};





const GetWalkingApplications = async (req, res) => {
    const reserveId = req.params.Reserve_ID;
    const ownerId = req.ID;

    try {
        if (!reserveId || !ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide reservation ID or ownerId."
            });
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

        const query = 'SELECT * FROM WalkingApplication WHERE Reserve_ID = $1 AND Application_Status = $2';
        const result = await pool.query(query, [reserveId, 'Pending']);
      
        res.status(200).json({
            status: "Success",
            message: "Applications retrieved successfully.",
            data: result.rows
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        });
    }
};




const getAllPendingRequests = async (req, res) => {
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
            LEFT JOIN Geofence gf ON wr.Reserve_ID = gf.Reserve_ID
            LEFT JOIN Pet p ON wr.Pet_ID = p.Pet_Id
            WHERE wr.Status = $1
            AND NOT EXISTS (
                SELECT 1
                FROM WalkingApplication wa
                WHERE wa.Reserve_ID = wr.Reserve_ID
                AND wa.Provider_ID = $2
            )
            ORDER BY wr.start_time
        `;
        const requestRes = await pool.query(requestQuery, ['Pending', providerId]);

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




const checkAndUpdateExpiredReservations = async () => {
    try {
        const currentTime = Date.now();
        const expiredReservations = await pool.query('SELECT * FROM WalkingApplication WHERE expirationTime < $1 AND Application_Status = $2', [currentTime, 'Pending']);

        for (const reservation of expiredReservations.rows) {
            // Update status to "Rejected"
            await pool.query('UPDATE WalkingApplication SET Application_Status = $1 WHERE Application_ID = $2', ['Rejected', reservation.application_id]);

            // Retrieve provider details for the expired reservation slot
            const providerQuery = await pool.query('SELECT email, UserName FROM ServiceProvider WHERE Provider_Id = $1', [reservation.provider_id]);
            const provider = providerQuery.rows[0];

            // Retrieve reservation details
            const reservationQuery = await pool.query('SELECT * FROM WalkingRequest WHERE Reserve_ID = $1', [reservation.reserve_id]);
            const reservationDetails = reservationQuery.rows[0];
         
            // Retrieve owner details
            const ownerQuery = await pool.query('SELECT * FROM Petowner WHERE Owner_Id = $1', [reservationDetails.owner_id]);
            const name = ownerQuery.rows[0].first_name;

            const petQuery = await pool.query('SELECT * FROM Pet WHERE Pet_Id=$1', [reservationDetails.pet_id]);
            const petName = petQuery.rows[0].name;

            // Format the start time and end time of the reservation
            const startTime = new Date(reservationDetails.start_time).toLocaleString();
            const endTime = new Date(reservationDetails.end_time).toLocaleString();

            // Construct the message
            const message = `Dear ${provider.username},\n\nWe regret to inform you that the Walking reservation has been automatically rejected due to inactivity.\n\nReservation Details:\nOwner Name: ${name}\nPet Name: ${petName}\nStart Time: ${startTime}\nEnd Time: ${endTime}\n\nThank you for using our services. Please contact the owner if you have any questions.\n\nBest Regards,\nPetYard Team`;

            // Send email notification
            await sendemail.sendemail({
                email: provider.email,
                subject: 'Your Walking Reservation Status',
                message
            });
        }
    } catch (error) {
        console.error("Error checking and updating expired reservations:", error);
    }
}

// Schedule periodic execution of the function
setInterval(checkAndUpdateExpiredReservations, 5000);

// Call the function immediately to handle potentially expired reservations
checkAndUpdateExpiredReservations();





const checkAndUpdateAllPendingRequestToRejectForProvider = async () => {
    try {
        const selectAllAccepted = await pool.query('SELECT * FROM WalkingRequest WHERE Status = $1', ['Accepted']);
        for (const reservation of selectAllAccepted.rows) {
            const pendingApplicationsQuery = await pool.query(
                'SELECT * FROM WalkingApplication WHERE Reserve_ID = $1 AND Application_Status = $2',
                [reservation.reserve_id, 'Pending']
            );

            for (const application of pendingApplicationsQuery.rows) {
                const providerId = application.provider_id;

                const providerQuery = await pool.query('SELECT * FROM ServiceProvider WHERE Provider_Id = $1', [providerId]);
                if (providerQuery.rows.length === 0) continue;

                const provider = providerQuery.rows[0];
                const providerName = provider.username;
                const providerEmail = provider.email;

                // Update the application status to 'Rejected'
                await pool.query('UPDATE WalkingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3', ['Rejected', reservation.reserve_id, providerId]);

                const message = `
                🐾 Pet Walking Application Update 🐾

                Dear ${providerName},

                We regret to inform you that your application for the following pet sitting request has been rejected:

                - **Reservation ID:** ${reservation.reserve_id}

                While this request wasn't successful, we appreciate your interest and encourage you to apply for other pet sitting opportunities available on PetYard.

                Thank you for your understanding and for being a valued member of our community.

                Best regards,
                The PetYard Team
                `;

                await sendemail.sendemail({
                    email: providerEmail,
                    subject: 'Pet Walking Application Update 🐾',
                    message
                });
            }
        }
    } catch (error) {
        console.error("Error checking and updating pending requests to reject:", error);
    }

}

// Set interval to run the function periodically
setInterval(checkAndUpdateAllPendingRequestToRejectForProvider, 6000);






const checkAndUpdateAllPendingRequestToRejectForPetowner = async () => {
    try {
        const selectAll = await pool.query('SELECT * FROM WalkingRequest WHERE Status = $1', ['Pending']);
        
        for (const reservation of selectAll.rows) {
            const currentTime = new Date().toISOString();
            
            if (currentTime >= reservation.start_time.toISOString()) {
                await pool.query('UPDATE WalkingRequest SET Status = $1 WHERE Reserve_ID = $2 AND Owner_ID = $3', ['Rejected', reservation.reserve_id, reservation.owner_id]);

                const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
                const ownerRes = await pool.query(ownerQuery, [reservation.owner_id]);
                if (ownerRes.rows.length === 0) continue;

                const owner = ownerRes.rows[0];
                const name = owner.first_name;
                const email = owner.email;
               

                const message = `
                🐾 Pet Walking Request Update 🐾

                Dear ${name},

                We regret to inform you that your pet  Walking request has been automatically rejected because the start time has passed without a sitter being assigned.

                - **Reservation ID:** ${reservation.reserve_id}

                We understand this may be disappointing, and we encourage you to post another request for pet  Walking. Our service providers are always eager to help care for your pet.

                Thank you for your understanding and for being a valued member of our community.

                Best regards,
                The PetYard Team
                `;

                await sendemail.sendemail({
                    email: email,
                    subject: 'Pet Sitting Request Update 🐾',
                    message
                });
            }
        }
    } catch (error) {
        console.error("Error checking and updating pending requests to reject:", error);
    }
}


// Set interval to run the function periodically
setInterval(checkAndUpdateAllPendingRequestToRejectForPetowner, 60000);





const processedEmails = new Set();

const checkAndUpdateCompleteReservations = async () => {
    try {


        const currentTime = new Date().toISOString();

        // Select reservations with End_time less than or equal to the current time and type as "Accepted"
        const reservations = await pool.query('SELECT * FROM WalkingRequest WHERE End_time <= $1 AND Status = $2', [currentTime, 'Accepted']);

        for (const reservation of reservations.rows) {
            // Retrieve provider name for the expired reservation slot
            const providerNameQuery = await pool.query(
                `SELECT * FROM ServiceProvider WHERE Provider_Id=$1`,
                [reservation.provider_id]
            );
           
            const providerName = providerNameQuery.rows[0].username;

            // Notify user to open the app and update the reservation status
            const ownerEmailQuery = await pool.query('SELECT * FROM Petowner WHERE Owner_Id=$1', [reservation.owner_id]);
            const ownerEmail = ownerEmailQuery.rows[0].email;

            const petQuery = await pool.query('SELECT * FROM Pet WHERE Pet_Id=$1', [reservation.pet_id]);
            const petName = petQuery.rows[0].name;

            // Format the start time and end time of the reservation
            const startTime = new Date(reservation.start_time).toLocaleString();
            const endTime = new Date(reservation.end_time).toLocaleString();

            // Compose message with emojis, start time, and end time
            const message = `🐾 Hello ${petName} Owner! 🐾\n\nYour reservation with ${providerName} has ended. 
                            Please open the app and update the status to "complete". 📲\n
                            Start Time: ${startTime}\nEnd Time: ${endTime}`;

            // Check if the email has already been processed
            if (!processedEmails.has(ownerEmail)) {
                // Send email with subject and message
                await sendemail.sendemail({
                    email: ownerEmail,
                    subject: '🐾 Update Reservation Status 🐾',
                    message
                });
                // Add the email to the set of processed emails
                processedEmails.add(ownerEmail);
            }
        }
    } catch (error) {
        console.error("Error checking and updating completed reservations:", error);
    }
}


const startWalk = async (req, res) => {
    const providerId = req.ID;
    const { Reserve_ID } = req.body;

    try {
        if (!providerId || !Reserve_ID) {
            return res.status(400).json({
                status: "Fail",
                message: "Please enter provider ID and reserve ID."
            });
        }

        // Fetch the reservation details
        const reservationQuery = 'SELECT * FROM WalkingRequest WHERE Reserve_ID = $1 AND Provider_ID = $2';
        const reservationResult = await pool.query(reservationQuery, [Reserve_ID, providerId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Reservation not found or not authorized."
            });
        }

        const reservation = reservationResult.rows[0];
        const currentTime = new Date();
        const startTime = new Date(reservation.start_time);

        if (currentTime < startTime) {
            return res.status(400).json({
                status: "Fail",
                message: "Cannot start the walk. The current time must be at least the start time."
            });
        }

        // Update the reservation status to 'In Progress'
        const updateReservationQuery = 'UPDATE WalkingRequest SET Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(updateReservationQuery, ['In Progress', Reserve_ID, providerId]);

        res.status(200).json({
            status: "Success",
            message: "Walk started successfully."
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};


// Set interval to run the function periodically
setInterval(checkAndUpdateCompleteReservations, 60000);

// Initial invocation of the function
checkAndUpdateCompleteReservations();


const completedApplication = async (req, res) => {
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

        const reservationQuery = 'SELECT * FROM WalkingRequest WHERE Reserve_ID = $1 AND Owner_ID = $2';
        const reservationResult = await pool.query(reservationQuery, [Reserve_ID, ownerId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found or not authorized."
            });
        }

        const applicationQuery = 'SELECT * FROM WalkingApplication WHERE Reserve_ID = $1 AND Provider_ID = $2';
        const applicationResult = await pool.query(applicationQuery, [Reserve_ID, Provider_ID]);

        if (applicationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting application not found or not authorized."
            });
        }

        const updateApplicationQuery = 'UPDATE WalkingRequest SET Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(updateApplicationQuery, ['Completed', Reserve_ID, Provider_ID]);

        res.status(200).json({
            status: "Success",
            message: "Sitting application Completed successfully"
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

const UpcomingRequests = async (req, res) => {
    const providerId = req.ID;

    try {
        if (!providerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Provider ID not provided."
            });
        }

        // Check if the provider exists
        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [providerId]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Provider doesn't exist."
            });
        }

        // Query to retrieve walking requests along with geofence information
        const walkingRequestsQuery = `
            SELECT 'Walking' AS service_type, wr.Reserve_ID, wr.Pet_ID, p.Name AS Pet_Name, p.Image AS Pet_Image, wr.Start_time, wr.End_time, wr.Final_Price, wr.Status,
                   po.First_name AS owner_first_name, po.Last_name AS owner_last_name, po.Email AS owner_email, po.Phone AS owner_phone, po.Location AS owner_location, po.Image AS owner_image,
                   gf.Center_Latitude AS geofence_latitude, gf.Center_Longitude AS geofence_longitude, gf.Radius AS geofence_radius
            FROM WalkingRequest wr
            JOIN Petowner po ON wr.Owner_ID = po.Owner_Id
            JOIN Pet p ON wr.Pet_ID = p.Pet_ID
            LEFT JOIN Geofence gf ON wr.Reserve_ID = gf.Reserve_ID
            WHERE wr.Provider_ID = $1 AND wr.Status = 'Accepted'
        `;

        const walkingRequests = await pool.query(walkingRequestsQuery, [providerId]);

        // Combine results
        const requests = [
            ...walkingRequests.rows,
        ];

        // Sort by Start_time in ascending order
        requests.sort((a, b) => new Date(a.Start_time) - new Date(b.Start_time));

        res.status(200).json({
            status: "Success",
            message: "Upcoming requests retrieved.",
            data: requests
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const UpcomingOwnerRequests = async (req, res) => {
    const ownerId = req.ID;

    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner ID not provided."
            });
        }

        // Check if the owner exists
        const ownerQuery = 'SELECT * FROM PetOwner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Owner doesn't exist."
            });
        }

        // Query to retrieve walking requests along with geofence information for the owner
        const walkingRequestsQuery = `
            SELECT 'Walking' AS service_type, 
                   wr.Reserve_ID, 
                   wr.Pet_ID, 
                   p.Name AS Pet_Name, 
                   p.Image AS Pet_Image, 
                   wr.Start_time, 
                   wr.End_time, 
                   wr.Final_Price, 
                   wr.Status,
                   sp.UserName AS provider_username, 
                   sp.Email AS provider_email, 
                   sp.Phone AS provider_phone, 
                   sp.Location AS provider_location, 
                   sp.Image AS provider_image,
                   gf.Center_Latitude AS geofence_latitude, 
                   gf.Center_Longitude AS geofence_longitude, 
                   gf.Radius AS geofence_radius
            FROM WalkingRequest wr
            LEFT JOIN ServiceProvider sp ON wr.Provider_ID = sp.Provider_Id
            LEFT JOIN Pet p ON wr.Pet_ID = p.Pet_ID
            LEFT JOIN Geofence gf ON wr.Reserve_ID = gf.Reserve_ID
            WHERE wr.Owner_ID = $1 
              AND (wr.Status = 'Accepted' OR wr.Status = 'In Progress')
        `;

        const walkingRequestsResult = await pool.query(walkingRequestsQuery, [ownerId]);

        // Combine results
        const requests = walkingRequestsResult.rows;

        // Sort by Start_time in ascending order
        requests.sort((a, b) => new Date(a.Start_time) - new Date(b.Start_time));

        res.status(200).json({
            status: "Success",
            message: "Upcoming requests retrieved.",
            data: requests
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};





const trackWalkingRequest = async (req, res) => {
    const ownerId = req.ID;
    const { Reserve_ID } = req.params.Reserve_ID;

    try {
        if (!ownerId || !Reserve_ID) {
            return res.status(400).json({
                status: "fail",
                message: "Missing information."
            });
        }

        // Check if the walking request exists and if the status is "In Progress"
        const query = `
            SELECT * FROM WalkingRequest 
            WHERE Reserve_ID = $1 AND Owner_ID = $2 AND Status = 'In Progress'
        `;
        const result = await pool.query(query, [Reserve_ID, ownerId]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "fail",
                message: "Walking request not found or not in progress."
            });
        }

        res.status(200).json({
            status: "success",
            message: "Walking request is in progress.",
            data: result.rows[0]
        });

    } catch (e) {
        console.error("Error:", e);
        return res.status(500).json({
            status: "fail",
            message: "Internal server error."
        });
    }
};



module.exports = {
    makeWalkingRequest,
    applyForWalkingRequest,
    GetPendingWalkingRequests,
    GetWalkingApplications,
    getAllPendingRequests,
    rejectApplication,
    acceptApplication,
    getALLAcceptedRequest,
    completedApplication,
    UpcomingRequests,
    startWalk,
    UpcomingOwnerRequests,
    trackWalkingRequest
   
}