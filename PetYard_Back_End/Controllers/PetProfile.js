const pool = require('../db');


const AddPet=async(req,res)=>
{
    const {Type,Name,Gender,Breed,Date_of_birth,Adoption_Date,Image,Weight}=req.body;
    const owner_id = req.Owner_Id; 
    try 
    {
        if (!Type || !Name || !Gender || !Breed || !Date_of_birth || !Adoption_Date || !Image || !Weight) 
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const addPetQuery = 'INSERT INTO Pet (Type, Name, Gender, Breed, Date_of_birth, Adoption_Date, Image, Owner_Id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)';
        await pool.query(addPetQuery, [Type, Name, Gender, Breed, Date_of_birth, Adoption_Date, Image, owner_id]);
        
        res.json({ message: "Add Pet successful" })
    } catch (error) 
    {
        console.error("Error Add Pet:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }

}

module.exports = {
    AddPet

}