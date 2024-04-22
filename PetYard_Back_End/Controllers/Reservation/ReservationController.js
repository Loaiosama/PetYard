const pool = require('../../db');



const getProvidersByType = async(req, res)=>{

    const ownerId = req.ID
    const {type} = req.params;
    try {
        if(!type)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }
        else{
            const Query = 'SELECT * FROM Petowner WHERE Owner_Id = $1';
            const result1 = await pool.query(Query, [ownerId]);

            if (result1.rows.length === 0) {
                return res.status(401).json({
                    status: "Fail",
                    message: "User doesn't exist"
                });
            }

            const client = await pool.connect();
            const providers = 'SELECT provider_id, username, phone, email, bio, date_of_birth, location, image FROM ServiceProvider WHERE Provider_Id IN (SELECT Provider_Id FROM Services WHERE Type = $1)';
            const result = await client.query(providers, [type]);
                
            if (result.rows.length === 0) {
                return res.status(401).json({
                    status: "Fail",
                    message: "No providers of given type."
                });
            }

            res.status(200).json({
                status: "Success",
                message: "Providers found",
                data: result.rows
            });

        }
    }catch (error) {
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

        res.status(200).json({
            status: "Success",
            data: result.rows[0]
        });

    } catch (error) {
        console.error("Error fetching provider info:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};


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
          const numDays = Math.ceil(timeDiff / (1000 * 3600 * 24)) + 1;
        console.log(numDays);

        const Price_Provider=await pool.query('SELECT Price FROM ServiceSlots WHERE Slot_ID=$1',[Slot_ID]);
        

        const Final_cost=numDays*Price_Provider.rows[0].price;


        const client = await pool.connect();
        const insertReservation =  'INSERT INTO Reservation (Slot_ID, Pet_ID, Start_time, End_time,Final_Price, Owner_ID) VALUES ($1, $2, $3, $4, $5,$6) RETURNING *';
        const result = await client.query(insertReservation, [Slot_ID, Pet_ID, Start_time, End_time,Final_cost ,ownerId]);

        client.release();


    

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




const GetReservation=async(req,res)=>{
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
        const status="Pending";
        const Reservation=await pool.query('SELECT * FROM Reservation WHERE Type=$1 AND Slot_ID IN (SELECT Slot_ID FROM ServiceSlots WHERE Provider_ID = $2)',[status,provider_id]);

    
        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :Reservation.rows
        });



        
    } catch (error) {
        console.error("Error ", error);
        res.status(500).json({
            message: "Internal server error."
        });
        
    }
}



const UpdateReservation=async(req,res)=>{
    const reserve_id=req.params.reserve_id;
    const provider_id = req.ID;
    const {slot_id,pet_id,owner_id,start_time,end_time,Type}=req.body;
    try {


        if (!provider_id || !reserve_id ) {
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

        const updateQuery = 'UPDATE Reservation SET Slot_ID =$1,  Pet_ID = $2, Owner_ID = $3, Start_time = $4, End_time = $5 , Type=$6 WHERE Reserve_ID = $7';
        await pool.query(updateQuery, [slot_id, pet_id, owner_id, start_time,end_time,Type,reserve_id]);

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



module.exports = {  
   GetSlotProvider,
   getProviderInfo,
   getProvidersByType,
   ReserveSlot,
   GetReservation,
   UpdateReservation
    
};