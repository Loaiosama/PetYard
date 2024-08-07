const pool = require('../../db');
const sendemail = require("../../Utils/email");

const makeRequest = async (req, res) => {
    const ownerId = req.ID;
    let { Pet_ID, Location, Start_time, End_time, Final_Price } = req.body;

    try {
        if (!ownerId || !Pet_ID || !Location || !Location.x || !Location.y || !Start_time || !End_time || !Final_Price) {
            return res.status(400).json({
                status: "fail",
                message: "Missing information."
            });
        }

        const startTime = new Date(Start_time);
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

        const locationString = `(${Location.x}, ${Location.y})`;

        // Perform the duplicate check using the location as text
        const duplicateCheckQuery = `
            SELECT * FROM SittingReservation 
            WHERE Pet_ID = $1 AND Start_time = $2 AND End_time = $3 AND Owner_ID = $4`;
        const duplicateCheckRes = await pool.query(duplicateCheckQuery, [Pet_ID, Start_time, End_time, ownerId]);

        if (duplicateCheckRes.rows.length > 0) {
            return res.status(400).json({
                status: "fail",
                message: "Duplicate request. A similar request already exists for this owner."
            });
        }

        const insertQuery = `
            INSERT INTO SittingReservation 
            (Pet_ID, Start_time, End_time, Final_Price, Owner_ID, Location) 
            VALUES ($1, $2, $3, $4, $5, $6) 
            RETURNING *`;
        const insertRes = await pool.query(insertQuery, [Pet_ID, Start_time, End_time, Final_Price, ownerId, locationString]);

        res.status(201).json({
            status: "success",
            message: "Request added successfully.",
            data: insertRes.rows
        });

    } catch (e) {
        console.error("Error:", e);
        return res.status(500).json({
            status: "fail",
            message: "Internal server error."
        });
    }
};




const applySittingRequest = async (req, res) => {
    const providerId = req.ID;
    let { Reserve_ID } = req.body;
    try {
        if (!providerId || !Reserve_ID) {
            return res.status(400).json({
                status: "Fail",
                message: "Provider ID or Reserve ID not provided."
            });
        }

        const Query = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const result1 = await pool.query(Query, [providerId]);

        if (result1.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const reservationQuery = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1';
        const reservationResult = await pool.query(reservationQuery, [Reserve_ID]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found"
            });
        }

        const applicationQuery = 'SELECT * FROM SittingApplication WHERE Reserve_ID = $1 AND Provider_ID = $2';
        const applicationResult = await pool.query(applicationQuery, [Reserve_ID, providerId]);

        if (applicationResult.rows.length > 0) {
            return res.status(409).json({
                status: "Fail",
                message: "You have already applied for this reservation."
            });
        }

        const ownerId = reservationResult.rows[0].owner_id;

        const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
        const ownerRes = await pool.query(ownerQuery, [ownerId]);
        const name = ownerRes.rows[0].first_name;
        const email = ownerRes.rows[0].email;
        const currentTime = Date.now();
        expirationTime = currentTime+ (6 * 60 * 60 * 1000);


        const applyQuery = "INSERT INTO SittingApplication (Reserve_ID, Provider_ID,expirationTime) VALUES ($1, $2,$3) RETURNING *";
        const applyRes = await pool.query(applyQuery, [Reserve_ID, providerId,expirationTime]);

        const message = `
        🐾 Pet Sitting Application Received! 🐾

        Dear ${name},

        We are excited to inform you that a pet sitter has applied for your pet sitting request! Here are the details of the application:

        - **Reservation ID:** ${Reserve_ID}
        - **Service Provider Name:** ${result1.rows[0].username}
        - **Start Time:** ${reservationResult.rows[0].start_time}
        - **End Time:** ${reservationResult.rows[0].end_time}

        Please review the application at your earliest convenience. If you have any questions or need further assistance, feel free to contact us.

        Thank you for choosing PetYard. We are committed to providing the best care for your pet.

        Best regards,
        The PetYard Team
    `;

        await sendemail.sendemail({
            email: email,
            subject: 'New Pet Sitting Application 🐾',
            message
        });

        res.status(201).json({
            status: "Success",
            message: "Application created successfully.",
            data: applyRes.rows[0]
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        });
    }
}


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

        const reservationQuery = 'SELECT * FROM SittingReservation WHERE Status = $1 ORDER BY start_time';
        const reservationResult = await pool.query(reservationQuery, ['Pending']);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Pending sitting reservations not found"
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Pending sitting reservations retrieved successfully.",
            data: reservationResult.rows
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        });
    }
};


const GetSittingReservations = async (req, res) => {
    const ownerId = req.ID;

    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide owner ID."
            });
        }

        const query = `
            SELECT sr.Reserve_ID, sr.Pet_ID, sr.Owner_ID, sr.Location, sr.Start_time, sr.End_time, sr.Final_Price, sr.Status, 
                   p.Name, p.Image
            FROM SittingReservation sr
            JOIN Pet p ON sr.Pet_ID = p.Pet_ID
            WHERE sr.Owner_ID = $1 AND sr.Provider_ID IS NULL AND sr.Status = 'Pending'
        `;
        const result = await pool.query(query, [ownerId]);

        res.status(200).json({
            status: "Success",
            reservations: result.rows,
        });
    } catch (error) {
        console.error("Error fetching sitting reservations", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};



// const getSittingApplications = async (req, res) => {
//     const reserveId = req.params.Reserve_ID;
//     const ownerId = req.ID;

//     try {
//         if (!reserveId || !ownerId) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Please provide reservation ID or ownerId."
//             });
//         }

//         const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
//         const ownerRes = await pool.query(ownerQuery, [ownerId]);

//         if (ownerRes.rows.length === 0) {
//             return res.status(400).json({
//                 status: "Fail",
//                 message: "Owner is not in Database"
//             });
//         }

//         const reservationQuery = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1';
//         const reservationResult = await pool.query(reservationQuery, [reserveId]);

//         if (reservationResult.rows.length === 0) {
//             return res.status(404).json({
//                 status: "Fail",
//                 message: "Sitting reservation not found"
//             });
//         }

//         const query = `
//             SELECT sa.*, sp.UserName AS provider_name, sp.Image AS provider_image
//             FROM SittingApplication sa
//             JOIN ServiceProvider sp ON sa.Provider_ID = sp.Provider_Id
//             WHERE sa.Reserve_ID = $1 AND sa.Application_Status = 'Pending'
//         `;
//         const result = await pool.query(query, [reserveId]);

//         res.status(200).json({
//             status: "Success",
//             message: "Pending applications retrieved successfully.",
//             data: result.rows
//         });

//     } catch (e) {
//         console.error("Error:", e);
//         res.status(500).json({
//             status: "Fail",
//             message: "Internal Server Error."
//         });
//     }
// };

const getSittingApplications = async (req, res) => {
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

        const reservationQuery = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1';
        const reservationResult = await pool.query(reservationQuery, [reserveId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found"
            });
        }

        const query = `
            SELECT sa.*, sp.UserName AS provider_name, sp.Image AS provider_image, 
                   COALESCE(r.provider_rating, 0) AS provider_rating, 
                   COALESCE(r.review_count, 0) AS review_count
            FROM SittingApplication sa
            JOIN ServiceProvider sp ON sa.Provider_ID = sp.Provider_Id
            LEFT JOIN (
                SELECT Provider_ID, AVG(Rate_value) AS provider_rating, COUNT(Rate_value) AS review_count
                FROM Review
                GROUP BY Provider_ID
            ) r ON sp.Provider_Id = r.Provider_ID
            WHERE sa.Reserve_ID = $1 AND sa.Application_Status = 'Pending'
        `;
        const result = await pool.query(query, [reserveId]);

        res.status(200).json({
            status: "Success",
            message: "Pending applications retrieved successfully.",
            data: result.rows
        });

    } catch (e) {
        console.error("Error:", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal Server Error."
        });
    }
};





const acceptSittingApplication = async (req, res) => {
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

        const reservationQuery = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1 AND Owner_ID = $2';
        const reservationResult = await pool.query(reservationQuery, [Reserve_ID, ownerId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found or not authorized."
            });
        }

        const applicationQuery = 'SELECT * FROM SittingApplication WHERE Reserve_ID = $1 AND Provider_ID = $2';
        const applicationResult = await pool.query(applicationQuery, [Reserve_ID, Provider_ID]);

        if (applicationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting application not found or not authorized."
            });
        }

        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [Provider_ID]);

        if (providerResult.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Provider not found."
            });
        }

        const name = providerResult.rows[0].username;
        const providerEmail = providerResult.rows[0].email;

        const startTime = reservationResult.rows[0].start_time;
        const endTime = reservationResult.rows[0].end_time;

        const overlapQuery = `
            SELECT * FROM SittingReservation
            WHERE Provider_ID = $1 AND Status = 'Accepted'
              AND (
                  (Start_time < $2 AND End_time > $2) OR
                  (Start_time < $3 AND End_time > $3) OR
                  (Start_time >= $2 AND End_time <= $3)
              )
        `;
        const overlapResult = await pool.query(overlapQuery, [Provider_ID, startTime, endTime]);

        if (overlapResult.rows.length > 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Provider has another reservation at the same time."
            });
        }

        const updateReservationQuery = 'UPDATE SittingReservation SET Provider_ID = $1, Status = $2 WHERE Reserve_ID = $3 RETURNING *';
        const updateReservationResult = await pool.query(updateReservationQuery, [Provider_ID, 'Accepted', Reserve_ID]);

        const updateApplicationQuery = 'UPDATE SittingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(updateApplicationQuery, ['Accepted', Reserve_ID, Provider_ID]);

        const rejectOtherApplicationsQuery = 'UPDATE SittingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID != $3';
        await pool.query(rejectOtherApplicationsQuery, ['Rejected', Reserve_ID, Provider_ID]);

        const message = `
        🐾 Pet Sitting Application Accepted! 🐾

        Dear ${name},

        We are thrilled to inform you that the pet owner has accepted your application for their pet sitting request! Here are the details:

        - **Reservation ID:** ${Reserve_ID}
        - **Start Time:** ${startTime}
        - **End Time:** ${endTime}

        Please prepare for the sitting accordingly. If you have any questions or need further assistance, please feel free to contact us.

        Thank you for being a part of PetYard and providing excellent care for pets.

        Best regards,
        The PetYard Team
        `;

        await sendemail.sendemail({
            email: providerEmail,
            subject: 'Pet Sitting Application Accepted 🐾',
            message
        });

        res.status(200).json({
            status: "Success",
            message: "Sitting reservation confirmed successfully",
            reservation: updateReservationResult.rows[0]
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
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

        const reservationQuery = `
            SELECT * FROM SittingReservation 
            WHERE Status = $1 
            AND Reserve_ID NOT IN (
                SELECT Reserve_ID FROM SittingApplication WHERE Provider_ID = $2
            )
            ORDER BY start_time`;
        const reservationResult = await pool.query(reservationQuery, ['Pending', providerId]);



        res.status(200).json({
            status: "Success",
            message: "Pending sitting reservations retrieved successfully.",
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



const checkAndUpdateExpiredReservations = async () => {
    try {
        const currentTime = Date.now();
        const expiredReservations = await pool.query('SELECT * FROM SittingApplication WHERE expirationTime < $1 AND Application_Status = $2', [currentTime, 'Pending']);

        for (const reservation of expiredReservations.rows) {
            // Update status to "Rejected"
            await pool.query('UPDATE SittingApplication SET Application_Status = $1 WHERE Application_ID = $2', ['Rejected', reservation.application_id]);

            // Retrieve provider details for the expired reservation slot
            const providerQuery = await pool.query('SELECT email, UserName FROM ServiceProvider WHERE Provider_Id = $1', [reservation.provider_id]);
            const provider = providerQuery.rows[0];

            // Retrieve reservation details
            const reservationQuery = await pool.query('SELECT * FROM SittingReservation WHERE Reserve_ID = $1', [reservation.reserve_id]);
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
            const message = `Dear ${provider.username},\n\nWe regret to inform you that the sitting reservation has been automatically rejected due to inactivity.\n\nReservation Details:\nOwner Name: ${name}\nPet Name: ${petName}\nStart Time: ${startTime}\nEnd Time: ${endTime}\n\nThank you for using our services. Please contact the owner if you have any questions.\n\nBest Regards,\nPetYard Team`;

            // Send email notification
            await sendemail.sendemail({
                email: provider.email,
                subject: 'Your Sitting Reservation Status',
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
        const selectAllAccepted = await pool.query('SELECT * FROM SittingReservation WHERE Status = $1', ['Accepted']);
        for (const reservation of selectAllAccepted.rows) {
            const pendingApplicationsQuery = await pool.query(
                'SELECT * FROM SittingApplication WHERE Reserve_ID = $1 AND Application_Status = $2',
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
                await pool.query('UPDATE SittingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3', ['Rejected', reservation.reserve_id, providerId]);

                const message = `
                🐾 Pet Sitting Application Update 🐾

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
                    subject: 'Pet Sitting Application Update 🐾',
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
        const selectAll = await pool.query('SELECT * FROM SittingReservation WHERE Status = $1', ['Pending']);
        
        for (const reservation of selectAll.rows) {
            const currentTime = new Date().toISOString();
            
            if (currentTime >= reservation.start_time.toISOString()) {
                await pool.query('UPDATE SittingReservation SET Status = $1 WHERE Reserve_ID = $2 AND Owner_ID = $3', ['Rejected', reservation.reserve_id, reservation.owner_id]);

                const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
                const ownerRes = await pool.query(ownerQuery, [reservation.owner_id]);
                if (ownerRes.rows.length === 0) continue;

                const owner = ownerRes.rows[0];
                const name = owner.first_name;
                const email = owner.email;
               

                const message = `
                🐾 Pet Sitting Request Update 🐾

                Dear ${name},

                We regret to inform you that your pet sitting request has been automatically rejected because the start time has passed without a sitter being assigned.

                - **Reservation ID:** ${reservation.reserve_id}

                We understand this may be disappointing, and we encourage you to post another request for pet sitting. Our service providers are always eager to help care for your pet.

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

        const reservationQuery = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1 AND Owner_ID = $2';
        const reservationResult = await pool.query(reservationQuery, [Reserve_ID, ownerId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found or not authorized."
            });
        }

        const applicationQuery = 'SELECT * FROM SittingApplication WHERE Reserve_ID = $1 AND Provider_ID = $2';
        const applicationResult = await pool.query(applicationQuery, [Reserve_ID, Provider_ID]);

        if (applicationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting application not found or not authorized."
            });
        }

        const updateApplicationQuery = 'UPDATE SittingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(updateApplicationQuery, ['Rejected', Reserve_ID, Provider_ID]);

        res.status(200).json({
            status: "Success",
            message: "Sitting application rejected successfully"
        });
    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

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

        const reservationQuery = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1 AND Owner_ID = $2';
        const reservationResult = await pool.query(reservationQuery, [Reserve_ID, ownerId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found or not authorized."
            });
        }

        const applicationQuery = 'SELECT * FROM SittingApplication WHERE Reserve_ID = $1 AND Provider_ID = $2';
        const applicationResult = await pool.query(applicationQuery, [Reserve_ID, Provider_ID]);

        if (applicationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting application not found or not authorized."
            });
        }

        const updateApplicationQuery = 'UPDATE SittingReservation SET Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
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



// Set interval to run the function periodically
setInterval(checkAndUpdateAllPendingRequestToRejectForPetowner, 60000);






const processedEmails = new Set();

const checkAndUpdateCompleteReservations = async () => {
    try {


        const currentTime = new Date().toISOString();

        // Select reservations with End_time less than or equal to the current time and type as "Accepted"
        const reservations = await pool.query('SELECT * FROM SittingReservation WHERE End_time <= $1 AND Status = $2', [currentTime, 'Accepted']);

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

// Set interval to run the function periodically
setInterval(checkAndUpdateCompleteReservations, 60000);

// Initial invocation of the function
checkAndUpdateCompleteReservations();




module.exports = {
    makeRequest,
    applySittingRequest,
    GetSittingReservations,
    getSittingApplications,
    acceptSittingApplication,
    GetAllRequset,
    getAllPendingRequests,
    rejectApplication,
    completedApplication
};

