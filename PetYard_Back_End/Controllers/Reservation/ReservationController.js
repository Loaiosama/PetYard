const pool = require('../../db');



const getproviders=async(req,res)=>{
    const Type=req.params.Type;
    const owner_id = req.ID;

try {

    if (!Type || !owner_id) {
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


        const Providers = 'SELECT * FROM Services WHERE Type = $1';
        const resquery = await pool.query(Providers, [Type]);

        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :resquery.rows
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

/*
getproviderInfo
reserveBoardingSlot*/


module.exports = {  
   getproviders
    
};