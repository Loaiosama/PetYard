const pool = require('../../db');
const sendemail = require("./../../Utils/email");


const getProvidersByType = async (req, res) => {
    const ownerId = req.ID;
    const { type } = req.params;

    try {
        if (!type) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist"
            });
        }

        const client = await pool.connect();
        const providersQuery = `
            SELECT sp.*, s.service_id, s.type 
            FROM ServiceProvider sp 
            JOIN Services s ON sp.Provider_Id = s.Provider_Id 
            WHERE s.Type = $1
        `;
        const providersResult = await client.query(providersQuery, [type]);

        const providersWithSlots = [];

        for (const provider of providersResult.rows) {
            const slotsQuery = `
                SELECT * 
                FROM ServiceSlots 
                WHERE Provider_ID = $1 
                AND Service_ID = $2 
                AND Start_time > NOW()
            `;
            const slotsResult = await client.query(slotsQuery, [provider.provider_id, provider.service_id]);

            if (slotsResult.rows.length > 0) {
                providersWithSlots.push(provider);
            }
        }

        client.release();

        if (providersWithSlots.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "No providers with available service slots of the given type."
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Providers found",
            data: providersWithSlots
        });

    } catch (error) {
        console.error("Error finding providers:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}



const getProviderInfo = async (req, res) => {
    const Provider_id = req.params.Provider_id;
    const owner_id = req.ID;

    try {
        if (!Provider_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide the provider ID"
            });
        }

        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [owner_id]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist"
            });
        }

        const query = 'SELECT provider_id, username, phone, email, bio, date_of_birth, location, image FROM ServiceProvider WHERE Provider_Id = $1';
        const result = await pool.query(query, [Provider_id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Provider not found"
            });
        }

        const provider = result.rows[0];

        // Calculate age of the provider
        const dob = new Date(provider.date_of_birth);
        const ageDiffMs = Date.now() - dob.getTime();
        const ageDate = new Date(ageDiffMs); // milliseconds from epoch
        const age = Math.abs(ageDate.getUTCFullYear() - 1970);

        // Add age to the provider object
        provider.age = age;

        const q = 'SELECT * FROM Services WHERE Provider_Id = $1';
        const res1 = await pool.query(q, [Provider_id]);

        res.status(200).json({
            status: "Success",
            provider,
            services: res1.rows
        });

    } catch (error) {
        console.error("Error fetching provider info:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}



const GetSlotProvider=async(req,res)=>{

    const owner_id = req.ID;
    const Provider_id=req.params.Provider_id;
    const Service_id=req.params.Service_id;


    try {
        if (!Provider_id || !Service_id || !owner_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        } 

        const Query = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const result = await pool.query(Query, [owner_id]);

        if (result.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist"
            });
        }


        const Slot = 'SELECT * FROM ServiceSlots WHERE Provider_ID = $1 And Service_ID=$2';
        const res1 = await pool.query(Slot, [Provider_id,Service_id]);
        if (res1.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Service Slots doesn't exist."
            });
        }
        const slot_id=res1.rows[0].slot_id;
        const status="Accepted";

        const Reservation = 'SELECT * FROM Reservation WHERE  Slot_ID=$1 And Type=$2';
        const res2 = await pool.query(Reservation, [slot_id,status]);
          
        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :res1.rows,
            data1:res2.rows
        });

    }
    catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }

}



const ReserveSlot = async(req, res) => {
    const ownerId = req.ID;
    const { Slot_ID, Pet_ID, Start_time, End_time } = req.body;

    try {

        if (!Slot_ID || !Pet_ID || !Start_time || !End_time) {
            return res.status(400).json({
                status: "Fail",
                message: "Info not complete."
            });
        }
        const Query = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const result1 = await pool.query(Query, [ownerId]);

        if (result1.rows.length === 0) {
            return res.status(401).json({
                    status: "Fail",
                    message: "User doesn't exist"
            });
        }
         
        // Parse dates from ISO 8601 format
        const startDate = new Date(Date.parse(Start_time));
        const endDate = new Date(Date.parse(End_time));
  
          // Calculate number of days between Start_time and End_time inclusively
          const timeDiff = endDate.getTime() - startDate.getTime();
          const numDays = Math.ceil(timeDiff / (1000 * 3600 * 24)) ;

          
          

        const Provider=await pool.query('SELECT * FROM ServiceSlots WHERE Slot_ID=$1',[Slot_ID]);
        
        const Final_cost=numDays*Provider.rows[0].price;
       
        const Provider_id=Provider.rows[0].provider_id;

        
        const currentTime = Date.now();
        expirationTime = currentTime + (6 * 60 * 60 * 1000);

        const client = await pool.connect();
        const insertReservation =  'INSERT INTO Reservation (Slot_ID, Pet_ID, Start_time, End_time,Final_Price, Owner_ID,expirationTime) VALUES ($1, $2, $3, $4, $5,$6,$7) RETURNING *';
        const result = await client.query(insertReservation, [Slot_ID, Pet_ID, Start_time, End_time,Final_cost ,ownerId,expirationTime]);

        client.release();

        const q=await pool.query('SELECT * FROM ServiceProvider WHERE Provider_Id=$1',[Provider_id]);
        
        const email= q.rows[0].email;
                
        

        const message = `Your have new Reservation Request \nOpen The Application To Enjoy💸`;

        await sendemail.sendemail({
            email: email,
            subject: 'Request for Reservation  (valid for 6 hours)',
            message
        });
    

        res.status(201).json({
            status: "Success",
            message: "Reservation created successfully",
            numberOfDays: numDays,
            Finalcost:Final_cost
        });

    } catch (error) {
        console.error("Error during reservation", error);
        res.status(500).json({
            message: "Internal server error."
        });
    }
}



const FeesDisplay=async (req,res)=>{
    const ownerId = req.ID;
    const { Slot_ID, Pet_ID, Start_time, End_time } = req.body;

    try {

        if (!Slot_ID || !Pet_ID || !Start_time || !End_time) {
            return res.status(400).json({
                status: "Fail",
                message: "Info not complete."
            });
        }
        const Query = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const result1 = await pool.query(Query, [ownerId]);

        if (result1.rows.length === 0) {
            return res.status(401).json({
                    status: "Fail",
                    message: "User doesn't exist"
            });
        }
         
        // Parse dates from ISO 8601 format
        const startDate = new Date(Date.parse(Start_time));
        const endDate = new Date(Date.parse(End_time));
  
          // Calculate number of days between Start_time and End_time inclusively
          const timeDiff = endDate.getTime() - startDate.getTime();
          const numDays = Math.ceil(timeDiff / (1000 * 3600 * 24)) ;

          
          

        const Provider=await pool.query('SELECT * FROM ServiceSlots WHERE Slot_ID=$1',[Slot_ID]);
        
        const Final_cost=numDays*Provider.rows[0].price;
        res.status(201).json({
            status: "Success",
            Finalcost:Final_cost
        });

    }
    catch(error){

        console.error("Error ", error);
        res.status(500).json({
            message: "Internal server error."
        });

    }
}



const GetProviderReservations = async (req, res) => {
    const provider_id = req.ID;
  
    try {
        if (!provider_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Info not complete."
            });
        }

        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [provider_id]);

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }

        const status = "Pending";
        const reservations = await pool.query(
            `SELECT R.*, R.Start_time , R.End_time,
            S.Start_time AS slot_start_time,
            S.End_time AS slot_end_time
             FROM Reservation R
             INNER JOIN ServiceSlots S ON R.Slot_ID = S.Slot_ID
             WHERE R.Type = $1 AND S.Provider_ID = $2`,
            [status, provider_id]
        );

        res.status(200).json({
            status: "Done",
            message: "Data retrieved successfully",
            data: reservations.rows
        });
        
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            message: "Internal server error."
        });
    }
}



const UpdateReservation=async(req,res)=>{
    const reserve_id=req.params.reserve_id;
    const provider_id = req.ID;
    let {slot_id,pet_id,owner_id,start_time,end_time,Type}=req.body;
    try {


        if (!provider_id || !reserve_id ) {
            return res.status(400).json({
                status: "Fail",
                message: "Info not complete."
            });
        }
        const providerQuery = 'SELECT * FROM ServiceProvider WHERE Provider_Id = $1';
        const providerResult = await pool.query(providerQuery, [provider_id]);
        const name=providerResult.rows[0].username;

        if (providerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "User doesn't exist."
            });
        }
     
        const Query = 'SELECT * FROM Reservation WHERE Slot_ID = $1 AND Pet_ID=$2 AND Owner_ID=$3';
        const Result = await pool.query(Query, [slot_id,pet_id,owner_id]);
      
       let time=Result.rows[0].expirationTime;
      
        if ( time <= Date.now()) {
            Type = "Rejected"; // Set type to Rejected if expired
            
        }
            

        const updateQuery = 'UPDATE Reservation SET Slot_ID =$1,  Pet_ID = $2, Owner_ID = $3, Start_time = $4, End_time = $5 , Type=$6 WHERE Reserve_ID = $7';
        await pool.query(updateQuery, [slot_id, pet_id, owner_id, start_time,end_time,Type,reserve_id]);



        const q=await pool.query('SELECT * FROM Petowner WHERE Owner_Id=$1',[owner_id]);
        const email= q.rows[0].email;
      
        const q1=await pool.query('SELECT * FROM Pet WHERE Pet_Id=$1',[pet_id]);
        const name_pet=q1.rows[0].name;

      
         if(Type ==="Accepted")
         {
                const message = `Your reservation got accepted ✅\nProvider_Name:${name}\nYour_Pet:${name_pet}\nStart_Time:${start_time}\nEnd_Time:${end_time}`;

                await sendemail.sendemail({
                    email: email,
                    subject: 'Your recent reservation status 😄',
                    message
                });

            }
            else if(Type==="Rejected")
            {
                const message = `Your reservation got Rejected 😞\nProvider_Name:${name}\nYour_Pet:${name_pet}\nStart_Time:${start_time}\nEnd_Time:${end_time}`;
                
                await sendemail.sendemail({
                    email: email,
                    subject: 'Your recent reservation status 😄',
                    message
                });

            }
       
        res.status(200).json({
            status: "Success",
            message: "Reservation updated successfully"
        });
        
    } catch (error) {

        console.error("Error ", error);
        res.status(500).json({
            message: "Internal server error."
        });
        
    }
 

}



const GetOwnerReservations = async (req, res) => {
    const ownerId = req.ID;

    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner ID not provided."
            });
        }

        // Check if the owner exists
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Owner doesn't exist."
            });
        }

        // Query to retrieve reservations along with provider information
        const reservationsQuery = `
            SELECT 
                R.*, 
                S.Start_time AS slot_start_time,
                S.End_time AS slot_end_time,
                SP.UserName AS provider_name
            FROM 
                Reservation R
            INNER JOIN 
                ServiceSlots S ON R.Slot_ID = S.Slot_ID
            INNER JOIN 
                ServiceProvider SP ON S.Provider_ID = SP.Provider_Id
            WHERE 
                R.Owner_ID = $1
        `;
        const { rows: reservations } = await pool.query(reservationsQuery, [ownerId]);

        res.status(200).json({
            status: "Success",
            message: "Reservations retrieved.",
            data: reservations
        });
    } catch (error) {
        console.error("Error retrieving reservations:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
}




const GetAllAcceptedandfinished = async (req, res) => {
    const ownerId = req.ID;

    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner ID not provided."
            });
        }

        // Check if the owner exists
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Owner doesn't exist."
            });
        }

        // Query to retrieve reservations along with provider information
        const reservationsQuery = `
        SELECT *
        FROM Reservation
        WHERE Owner_ID = $1
            AND Type = 'Accepted'
            AND $2 >= End_time;
    `;
        const { rows: reservations } = await pool.query(reservationsQuery, [ownerId, new Date()]);


        res.status(200).json({
            status: "Success",
            message: "Accepted and finished reservations retrieved.",
            data: reservations
        });
    } catch (error) {
        console.error("Error :", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
}


const updateCompletedReservations=async(req,res)=>{
    const reserve_id=req.params.reserve_id;
    const ownerId = req.ID;
    let {slot_id,pet_id,start_time,end_time,Type}=req.body;
    try {


        if (!ownerId || !reserve_id ) {
            return res.status(400).json({
                status: "Fail",
                message: "Info not complete."
            });
        }
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Owner doesn't exist."
            });
        }

       

        const updateQuery = 'UPDATE Reservation SET Slot_ID =$1,  Pet_ID = $2, Owner_ID = $3, Start_time = $4, End_time = $5 , Type=$6 WHERE Reserve_ID = $7';
        await pool.query(updateQuery, [slot_id, pet_id, ownerId, start_time,end_time,Type,reserve_id]);

       
        res.status(200).json({
            status: "Success",
            message: "Reservation updated successfully"
        });
        
    } catch (error) {

        console.error("Error ", error);
        res.status(500).json({
            message: "Internal server error."
        });
        
    }
}


const GetALLCompleted = async (req, res) => {
    const ownerId = req.ID;

    try {
        if (!ownerId) {
            return res.status(400).json({
                status: "Fail",
                message: "Owner ID not provided."
            });
        }

        // Check if the owner exists
        const ownerQuery = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
        const ownerResult = await pool.query(ownerQuery, [ownerId]);

        if (ownerResult.rows.length === 0) {
            return res.status(401).json({
                status: "Fail",
                message: "Owner doesn't exist."
            });
        }

        // Query to retrieve completed reservations
        const reservationsQuery = `
            SELECT *
            FROM Reservation
            WHERE Owner_ID = $1
            AND Type = 'Completed'
        `;
        const { rows: reservations } = await pool.query(reservationsQuery, [ownerId]);

        res.status(200).json({
            status: "Success",
            message: "Completed reservations retrieved.",
            data: reservations
        });
    } catch (error) {
        console.error("Error :", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error."
        });
    }
}


//  After a certain amount of hours Reject automatically  

const checkAndUpdateExpiredReservations = async () => {
    try {
        const currentTime = Date.now();
        const expiredReservations = await pool.query('SELECT * FROM Reservation WHERE expirationTime < $1 AND Type = $2', [currentTime, 'Pending']);
         
        for (const reservation of expiredReservations.rows) {
            // Update status to "Rejected"
            await pool.query('UPDATE Reservation SET Type = $1 WHERE Reserve_ID = $2', ['Rejected', reservation.reserve_id]);
            
            // Retrieve provider name for the expired reservation slot
            const providerNameQuery = await pool.query(
                `SELECT sp.UserName AS Provider_Name
                 FROM ServiceSlots ss
                 JOIN ServiceProvider sp ON ss.Provider_ID = sp.Provider_Id
                 WHERE ss.Slot_ID = $1`,
                [reservation.slot_id]
            );
            const providerName = providerNameQuery.rows[0].provider_name; // Fixed typo here

            // Notify user about the rejection
            const ownerEmailQuery = await pool.query('SELECT * FROM Petowner WHERE Owner_Id=$1', [reservation.owner_id]);
            const ownerEmail = ownerEmailQuery.rows[0].email;
          
            const petQuery = await pool.query('SELECT * FROM Pet WHERE Pet_Id=$1', [reservation.pet_id]);
            const petName = petQuery.rows[0].name;
            const message = `Your reservation got Rejected 😞\nProvider_Name:${providerName}\nYour_Pet:${petName}\nStart_Time:${reservation.start_time}\nEnd_Time:${reservation.end_time}`;
                
            await sendemail.sendemail({
                email: ownerEmail,
                subject: 'Your recent reservation status 😄',
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






// Create a Set to store processed email addresses
const processedEmails = new Set();

const checkAndUpdateCompleteReservations = async () => {
    try {

      
        const currentTime = new Date().toISOString();
        
        // Select reservations with End_time less than or equal to the current time and type as "Accepted"
        const reservations = await pool.query('SELECT * FROM Reservation WHERE End_time <= $1 AND Type = $2', [currentTime, 'Accepted']);
         
        for (const reservation of reservations.rows) {
            // Retrieve provider name for the expired reservation slot
            const providerNameQuery = await pool.query(
                `SELECT sp.UserName AS Provider_Name
                 FROM ServiceSlots ss
                 JOIN ServiceProvider sp ON ss.Provider_ID = sp.Provider_Id
                 WHERE ss.Slot_ID = $1`,
                [reservation.slot_id]
            );
            const providerName = providerNameQuery.rows[0].provider_name;

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
   GetSlotProvider,
   getProviderInfo,
   getProvidersByType,
   ReserveSlot,
   GetProviderReservations,
   UpdateReservation,
   GetOwnerReservations,
   FeesDisplay,
   GetAllAcceptedandfinished,
   updateCompletedReservations,
   GetALLCompleted
    
};