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

       
        const ownerQuery = "SELECT * FROM Petowner WHERE Owner_Id = $1";
        const ownerRes = await pool.query(ownerQuery, [ownerId]);

        if (ownerRes.rows.length === 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner is not in Database"
            });
        }


   
        const locationString = `(${Location.x}, ${Location.y})`;

        const insertQuery = `
            INSERT INTO SittingReservation 
            (Pet_ID, Start_time, End_time, Final_Price, Owner_ID, Location) 
            VALUES ($1, $2, $3, $4, $5,$6) 
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
            status: "Fail",
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

        const applyQuery = "INSERT INTO SittingApplication (Reserve_ID, Provider_ID) VALUES ($1, $2) RETURNING *";
        const applyRes = await pool.query(applyQuery, [Reserve_ID, providerId]);

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

        if (!ownerId ) {
            return res.status(400).json({
                status: "Fail",
                message: "ownerId ID ."
            });
        }
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

        const reservationQuery = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1';
        const reservationResult = await pool.query(reservationQuery, [reserveId]);

        if (reservationResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found"
            });
        }

        const Query = 'SELECT * FROM SittingApplication WHERE Reserve_ID = $1';
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





const acceptSittingApplication = async (req, res) => {
    const ownerId = req.ID;
    const { Reserve_ID, Provider_ID } = req.body;

    try {

        if(!Reserve_ID || !ownerId || !Provider_ID){
            return res.status(400).json({
                status: "Fail",
                message: "Please provide reservation ID or ownerId or Provider_ID."
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

        const query = 'SELECT * FROM SittingReservation WHERE Reserve_ID = $1 AND Owner_ID = $2';
        const result = await pool.query(query, [Reserve_ID, ownerId]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting reservation not found or not authorized"
            });
        }

        const Query = 'SELECT * FROM SittingApplication WHERE Reserve_ID = $1';
        const Result = await pool.query(Query, [Reserve_ID]);
        if (Result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Sitting Application not found or not authorized"
            });
        }

        const queryProvider = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const resultProvider = await pool.query(queryProvider, [Provider_ID]);
        const name=resultProvider.rows[0].username;
        const providerEmail = resultProvider.rows[0].email; 



        const updateQuery = 'UPDATE SittingReservation SET Provider_ID = $1, Status = $2 WHERE Reserve_ID = $3 RETURNING *';
        const updateResult = await pool.query(updateQuery, [Provider_ID, 'Accepted', Reserve_ID]);

        const applicationQuery = 'UPDATE SittingApplication SET Application_Status = $1 WHERE Reserve_ID = $2 AND Provider_ID = $3';
        await pool.query(applicationQuery, ['Accepted', Reserve_ID, Provider_ID]);


        const message = `
        🐾 Pet Sitting Application Accepted! 🐾

        Dear ${name},

        We are thrilled to inform you that the pet owner has accepted your application for their pet sitting request! Here are the details:

        - **Reservation ID:** ${Reserve_ID}
        - **Start Time:** ${result.rows[0].start_time}
        - **End Time:** ${result.rows[0].end_time}

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
    acceptSittingApplication,
    GetAllRequset
};