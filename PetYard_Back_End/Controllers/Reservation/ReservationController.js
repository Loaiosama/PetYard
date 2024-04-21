const pool = require('../../db');




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


module.exports = {  
   GetSlotProvider,
   getProviderInfo,
    
};