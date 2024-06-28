const pool = require('../../db');
const sendemail = require("../../Utils/email");
const moment = require('moment-timezone');

const createClinicSlots = async (req, res) => {
    const providerId = req.ID;
    let { Start_time, End_time, Slot_length } = req.body;

    try {
        if (!providerId || !Start_time || !End_time  || !Slot_length) {
            return res.status(400).json({
                status: "Fail",
                message: "Missing information."
            });
        }

        const startTime = new Date(Start_time);
        const endTime = new Date(End_time);

        const checkOverlapQuery = `
            SELECT * FROM ClinicServiceSlots
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

            const slotsQuery = `INSERT INTO ClinicServiceSlots (Provider_ID, Start_time, End_time) VALUES ($1, $2, $3) RETURNING *`;
            const queryRes = await pool.query(slotsQuery, [providerId, currentStartTime.toISOString(), currentEndTime.toISOString()]);

            const slotData = queryRes.rows[0];

          
            const adjustedSlot = {
                slot_id: slotData.slot_id,
                provider_id: slotData.provider_id,
                start_time: new Date(slotData.start_time).toISOString(), 
                end_time: new Date(slotData.end_time).toISOString(),     
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
            message: "Clinic slots created successfully.",
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


const setClinicTypesForProvider = async (req, res) => {
    const providerId = req.ID;
    const { clinicType,price } = req.body;

    try {
        if (!providerId || !clinicType || !price) {
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

        const checkQuery = 'SELECT * FROM ProviderClinicTypes WHERE Provider_ID = $1 AND Clinic_Type = $2';
        const checkResult = await pool.query(checkQuery, [providerId, clinicType]);

        if (checkResult.rows.length > 0) {
            return res.status(400).json({
                status: "Fail",
                message: "Clinic type already set for this provider."
            });
        }

        await pool.query('INSERT INTO ProviderClinicTypes (Provider_ID, Clinic_Type,Price) VALUES ($1, $2,$3)', [providerId, clinicType,price]);

        res.status(201).json({
            status: "Success",
            message: "Clinic types set successfully."
        });

    } catch (e) {

        console.error("Error: ", e);
        res.status(500).json({
            status: "Failed",
            message: "Internal server error."
        });
        }
    
};


const getClinicTypesForProvider = async (req, res) => {
    const providerId = req.ID;
 

    try {
        if (!providerId ) {
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

        const result = await pool.query('SELECT Clinic_Type FROM ProviderClinicTypes WHERE Provider_ID = $1', [providerId]);

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

const updateClinicTypesForProvider = async (req, res) => {
    const providerId = req.ID;
    const { clinicType } = req.body;
    const { oldclinicTypeid } = req.params;

    try {

        if (!providerId || !clinicType || !oldclinicTypeid) {
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

        const existingClinicTypeQuery = 'SELECT * FROM ProviderClinicTypes WHERE ID = $1';
        const existingClinicTypeResult = await pool.query(existingClinicTypeQuery, [oldclinicTypeid]);

        if (existingClinicTypeResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Provider does not have this Clinic type."
            });
        }

        // Check if the new grooming type already exists for the same provider
        const duplicateCheckQuery = 'SELECT * FROM ProviderClinicTypes WHERE Provider_ID = $1 AND Clinic_Type = $2';
        const duplicateCheckResult = await pool.query(duplicateCheckQuery, [providerId, clinicType]);

        if (duplicateCheckResult.rows.length > 0) {
            return res.status(400).json({
                status: "Fail",
                message: "This clinic type already exists for the provider."
            });
        }

        const updateQuery = 'UPDATE ProviderClinicTypes SET Clinic_Type = $1 WHERE ID = $2';
        await pool.query(updateQuery, [clinicType, oldclinicTypeid]);

        res.status(200).json({
            status: "Success",
            message: "clinic types updated successfully."
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Failed",
            message: "Internal server error."
        });
    }
};
const DeleteClinicTypesForProvider = async (req, res) => {
    const providerId = req.ID;
    const { clinicTypeId } = req.params;

    try {
        if (!providerId || !clinicTypeId) {
            return res.status(400).json({
                status: "Fail",
                message: "Missing or invalid information."
            });
        }

        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [providerId]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const clinicTypeQuery = 'SELECT * FROM ProviderClinicTypes WHERE ID = $1 AND Provider_ID = $2';
        const clinicTypeResult = await pool.query(clinicTypeQuery, [clinicTypeId, providerId]);

        if (clinicTypeResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "clinic type not found for this provider."
            });
        }

        const deleteQuery = 'DELETE FROM ProviderClinicTypes WHERE ID = $1 AND Provider_ID = $2';
        await pool.query(deleteQuery, [clinicTypeId, providerId]);

        res.status(200).json({
            status: "Success",
            message: "Clinic type deleted successfully."
        });

    } catch (e) {
        console.error("Error: ", e);
        res.status(500).json({
            status: "Failed",
            message: "Internal server error."
        });
    }
};
const getClinicSlots = async (req, res) => {
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

        const slotsQuery = "SELECT * FROM ClinicServiceSlots WHERE Provider_ID = $1";
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
            clinic_type: slot.clinic_type
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


const getAllClinicProviders = async (req, res) => {
    const ownerId = req.ID;
    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner ID is missing."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const query = `
            SELECT DISTINCT 
                sp.Provider_Id,
                sp.UserName,
                sp.Phone,
                sp.Email,
                sp.Bio,
                sp.Date_of_birth,
                sp.Location::text AS Location, -- Convert point type to text
                sp.Image
            FROM 
                ServiceProvider sp
            JOIN 
                ClinicServiceSlots gss ON sp.Provider_Id = gss.Provider_ID
        `;
        
        const result = await pool.query(query);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No Clinic service providers found."
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Clinic service providers retrieved successfully.",
            data: result.rows
        });

    } catch (error) {
        console.error("Error fetching Clinic providers:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};

const getClinicSlotsForProvider = async (req, res) => {
    const ownerId = req.ID;
    const provider_id = req.params.provider_id;
    try {
        if (!provider_id || !ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Provider ID or Owner ID is missing."
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const providerQuery = "SELECT * FROM ServiceProvider WHERE Provider_Id = $1";
        const providerResult = await pool.query(providerQuery, [provider_id]);

        if (providerResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Provider is not registered in the database."
            });
        }

        const slotsQuery = "SELECT * FROM ClinicServiceSlots WHERE Provider_ID = $1 AND Type = 'Pending'";
        const slotsResult = await pool.query(slotsQuery, [provider_id]);

        if (slotsResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No pending slots created."
            });
        }

        // Adjusting the times for display (+3 hours)
        const slots = slotsResult.rows.map(slot => ({
            slot_id: slot.slot_id,
            provider_id: slot.provider_id,
            start_time: moment.utc(slot.start_time).add(3, 'hours').toISOString(), // Adding 3 hours to start_time
            end_time: moment.utc(slot.end_time).add(3, 'hours').toISOString(),     // Adding 3 hours to end_time
            price: slot.price,
            grooming_type: slot.clinic_type
        }));

        res.status(200).json({
            status: "Success",
            message: "Pending slots retrieved successfully.",
            data: slots
        });

    } catch (error) {
        console.error("Error: ", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
};


const bookClinicSlot = async (req, res) => {
    const ownerId = req.ID;
    const { slot_id, pet_id, clinic_types } = req.body; // grooming_types should be an array

    try {
        if (!ownerId || !slot_id || !pet_id || !Array.isArray(clinic_types) || clinic_types.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Missing information."
            });
        }

        // Check if owner exists
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Owner not found."
            });
        }

        const owner = ownerResult.rows[0];

        // Check if pet exists
        const petQuery = 'SELECT * FROM Pet WHERE Pet_ID = $1';
        const petResult = await pool.query(petQuery, [pet_id]);

        if (petResult.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Pet not found."
            });
        }

        // Check if grooming slot exists
        const slotQuery = 'SELECT * FROM ClinicServiceSlots WHERE Slot_ID = $1';
        const slotResult = await pool.query(slotQuery, [slot_id]);

        if (slotResult.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Clinic slot not found."
            });
        }

        const slot = slotResult.rows[0];
        const providerId = slot.provider_id;

        // Check if provider exists
        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [providerId]);

        if (providerResult.rows.length === 0) {
            return res.status(404).json({
                status: "fail",
                message: "Provider is not registered in the database."
            });
        }

        const provider = providerResult.rows[0];

        // Check for duplicate reservations
        const reservationCheckQuery = `
            SELECT * FROM ClinicReservation 
            WHERE Slot_ID = $1 AND Pet_ID = $2 AND Owner_ID = $3`;
        const reservationCheckResult = await pool.query(reservationCheckQuery, [slot_id, pet_id, ownerId]);

        if (reservationCheckResult.rows.length > 0) {
            return res.status(400).json({
                status: "fail",
                message: "You have already booked this Clinic slot for your pet."
            });
        }

        // Calculate the final price
        let finalPrice = 0;
        for (const clinicType of clinic_types) {
            const priceQuery = `
                SELECT Price FROM ProviderClinicTypes 
                WHERE Provider_ID = $1 AND Clinic_Type = $2`;
            const priceResult = await pool.query(priceQuery, [providerId, clinicType]);

            if (priceResult.rows.length === 0) {
                return res.status(400).json({
                    status: "fail",
                    message: `Clinic type '${clinicType}' not available for the selected provider.`
                });
            }

            finalPrice += priceResult.rows[0].price;
        }

        // Insert the reservation
        const insertQuery = `
            INSERT INTO ClinicReservation (Slot_ID, Pet_ID, Owner_ID, Start_time, End_time, Final_Price, Clinic_Type)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING *`;
        const insertResult = await pool.query(insertQuery, [slot_id, pet_id, ownerId, slot.start_time, slot.end_time, finalPrice, clinic_types]);

        // Update the grooming slot status
        const updateQuery = `
            UPDATE ClinicServiceSlots 
            SET Type = $1 
            WHERE Slot_ID = $2`;
        await pool.query(updateQuery, ['Accepted', slot_id]);

        const message = `
            Dear ${provider.username},

            Exciting news! You have a new reservation for your clinic services. 

            Here are the details of the booking:
            - Owner Name: ${owner.first_name}
            - Clinic Types: ${clinic_types.join(', ')}
            - Start Time: ${new Date(slot.start_time).toLocaleString()}
            - End Time: ${new Date(slot.end_time).toLocaleString()}
            - Final Price: $${finalPrice}

            Please open the PetYard application to manage this reservation. We appreciate your continued dedication to providing excellent Clinic services.

            Best regards,
            PetYard Team
        `;

        await sendemail.sendemail({
            email: provider.email,
            subject: 'New Clinic Reservation Request',
            message
        });

        res.status(201).json({
            status: "success",
            message: "Clinic slot booked successfully.",
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



const getClinicReservations = async (req, res) => { 
    const ownerId = req.ID;
    try {
        if (!ownerId ) {
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
        const query = 'SELECT * FROM ClinicReservation WHERE Owner_ID = $1 ORDER BY Start_time';
        const result = await pool.query(query, [ownerId]);

        res.status(200).json({
            status: "success",
            message: "Clinic reservations retrieved successfully.",
            data: result.rows
        });
    } catch (error) {
        console.error("Error fetching Clinic reservations", error);
        res.status(500).json({
            status: "fail",
            message: "Internal server error"
        });
    }
};

const updateClinicReservationtocomplete = async (req, res) => {
    const ownerId = req.ID; 
    const { Slot_ID } = req.params;
    const { Type } = req.body;

    try {
        
        if (!ownerId || !Slot_ID || !Type) {
            return res.status(400).json({ error: 'Missing required parameters' });
        }
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(400).json({
                status: "fail",
                message: "Owner not found."
            });
        }

         // Check if grooming slot exists
         const slotQuery = 'SELECT * FROM ClinicServiceSlots WHERE Slot_ID = $1';
         const slotResult = await pool.query(slotQuery, [Slot_ID]);
 
         if (slotResult.rows.length === 0) {
             return res.status(400).json({
                 status: "fail",
                 message: "Clinic slot not found."
             });
         }

        // Update the reservation to complete in the database
        const updateQuery = await pool.query(
            'UPDATE ClinicServiceSlots SET Type = $1 WHERE Slot_ID = $2 ',
            [Type, Slot_ID]
        );


        if (updateQuery.rowCount === 0) {
            return res.status(404).json({ error: 'No matching reservation found' });
        }

        // Send a success response
        return res.status(200).json({ message: 'Clinic reservation updated successfully' });
    } catch (error) {
        console.error('Error updating Clinic reservation:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};



const processedEmails = new Set();

const checkAndUpdateCompleteReservations = async () => {
    try {
        const currentTime = new Date().toISOString();
        
        // Select grooming slots with End_time less than or equal to the current time and Type as "Accepted"
        const reservations = await pool.query('SELECT * FROM ClinicServiceSlots WHERE End_time <= $1 AND Type = $2', [currentTime, 'Accepted']);
        
        for (const reservation of reservations.rows) {
            // Retrieve provider name for the expired grooming slot
            const providerNameQuery = await pool.query(
                `SELECT sp.UserName AS Provider_Name
                 FROM ClinicServiceSlots gs
                 JOIN ServiceProvider sp ON gs.Provider_ID = sp.Provider_Id
                 WHERE gs.Slot_ID = $1`,
                [reservation.slot_id]
            );
            const providerName = providerNameQuery.rows[0]?.provider_name; // Use optional chaining to handle undefined

            // Retrieve owner_id and pet_id from GroomingReservation
            const queryResult = await pool.query('SELECT * FROM ClinicReservation WHERE Slot_ID=$1', [reservation.slot_id]);
            if (queryResult.rows.length === 0) {
                console.log(`No reservation found for slot_id ${reservation.slot_id}`);
                continue; // Skip to the next reservation if no matching reservation is found
            }

            const owner_id = queryResult.rows[0]?.owner_id;
            const pet_id = queryResult.rows[0]?.pet_id;

            // Retrieve owner email and pet name
            const ownerEmailQuery = await pool.query('SELECT * FROM Petowner WHERE Owner_Id=$1', [owner_id]);
            const ownerEmail = ownerEmailQuery.rows[0]?.email; // Use optional chaining to handle undefined

            const petQuery = await pool.query('SELECT * FROM Pet WHERE Pet_Id=$1', [pet_id]);
            const petName = petQuery.rows[0]?.name; // Use optional chaining to handle undefined

            // Check if essential data exists and if the email has already been processed
            if (ownerEmail && petName && providerName && !processedEmails.has(ownerEmail)) {
                // Format the start time and end time of the reservation
                const startTime = new Date(reservation.start_time).toLocaleString();
                const endTime = new Date(reservation.end_time).toLocaleString();

                // Compose message with emojis, start time, and end time
                const message = `🐾 Hello ${petName} Owner! 🐾
                Your Clinic appointment with ${providerName} has ended. 
                Please open the app and update the status to "complete". 📲
                Start Time: ${startTime}
                End Time: ${endTime}`;

                // Send email with subject and message
                await sendemail.sendemail({
                    email: ownerEmail,
                    subject: '🐾 Update Clinic Reservation Status 🐾',
                    message
                });

                // Add the email to the set of processed emails
                processedEmails.add(ownerEmail);
            }
        }
    } catch (error) {
        console.error("Error checking and updating completed Clinic reservations:", error);
    }
}
// Set interval to run the function periodically (every 60 seconds in this case)
setInterval(checkAndUpdateCompleteReservations, 60000);

// Initial invocation of the function
checkAndUpdateCompleteReservations();



module.exports = {
    createClinicSlots,
    setClinicTypesForProvider,
    getClinicTypesForProvider,
    updateClinicTypesForProvider,
    DeleteClinicTypesForProvider,
    getClinicSlots,
    getAllClinicProviders,
    getClinicSlotsForProvider,
    bookClinicSlot,
    getClinicReservations,
    updateClinicReservationtocomplete
 
}