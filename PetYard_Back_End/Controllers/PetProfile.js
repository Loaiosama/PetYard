const pool = require('../db');


const AddPet = async(req,res)=>
{
    const {Type,Name,Gender,Breed,Date_of_birth,Adoption_Date,Image,Weight}=req.body;
    const owner_id = req.ID; 
    try 
    {
        if (!Type || !Name || !Gender || !Breed || !Date_of_birth || !Adoption_Date || !Image || !Weight) 
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const addPetQuery = 'INSERT INTO Pet (Type, Name, Gender, Breed, Date_of_birth, Adoption_Date, Image, Weight ,Owner_Id) VALUES ($1, $2, $3, $4, $5, $6, $7,$8,$9)';
        await pool.query(addPetQuery, [Type, Name, Gender, Breed, Date_of_birth, Adoption_Date, Image, Weight,owner_id]);
        
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
const GetAllPet = async(req,res)=>{

    const owner_id = req.ID; 

    try {
        if(!owner_id)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
            
        }
        const getAllpet = await pool.query('SELECT * FROM Pet WHERE owner_id=$1',[owner_id]);
        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :getAllpet.rows
        });
        
    } 
    catch (error)
    {
        console.error("Error Add Pet:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
        
    }
}

const GetPet = async(req,res)=>{

    const {Pet_Id} =req.params;  
    const owner_id = req.ID; 

    try
    {
        if(!Pet_Id || !owner_id)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
        }

        const getpet = await pool.query('SELECT * FROM Pet WHERE Pet_Id = $1 AND owner_id = $2', [Pet_Id, owner_id]);

        res.status(200).json({
            status :"Done",
            message : "One Data Is Here",
            data :getpet.rows
        });  
    } 
    catch (error)
    {
        console.error("Error Add Pet:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
}

const RemoveAllPet = async(req,res)=>{

    const owner_id = req.ID; 
    

 try {

    if(!owner_id)
    {
        return res.status(400).json({
            status: "Fail",
            message: "Some Error Haben"
        });
    }

    const removeallpet = await pool.query('DELETE FROM Pet WHERE  owner_id = $1',[owner_id]);

    res.status(200).json({
        status :"Done",
        message : "Delete All Pets Successfully"
      
    }); 
    
 } catch (error) {
    console.error("Error Add Pet:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });  
 }

}

const RemovePet = async(req,res)=>{
    const {Pet_Id} =req.params;  
    const owner_id = req.ID; 
 
    try {

        if(!owner_id || !Pet_Id)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
        }

        const removepet = await pool.query('DELETE FROM Pet WHERE  owner_id = $1 AND Pet_Id = $2 ',[owner_id,Pet_Id]);
        res.status(200).json({
            status :"Done",
            message : "Delete Pet Successfully"
          
        }); 

    } catch (error) {
        console.error("Error Add Pet:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });  
        
    }



}

const updatePetProfile = async(req,res)=>{
    const {Name,Gender,Breed,Date_of_birth,Adoption_Date,Weight,Image} = req.body;
    const {Pet_Id}=req.params;
    const owner_id = req.ID; 

    try {
        if(!Pet_Id || !owner_id)
        {
            return res.status(400).json({
                status: "Fail",
                message: "Some Error Haben"
            });
        }
        const UpdatePet =await pool.query('UPDATE Pet SET  Name=$1,Gender=$2,Breed=$3,Date_of_birth=$4,Adoption_Date=$5,Weight=$6,Image=$7 WHERE Pet_Id=$8 AND owner_id=$9',[Name,Gender,Breed,Date_of_birth,Adoption_Date,Weight,Image,Pet_Id,owner_id]);

        res.status(200).json({
            status: "Success",
            message: " update successfully"
        }); 

        }catch (error){
            console.error("Error Add Pet:", error);
            res.status(500).json({
                status: "Fail",
                message: "Internal server error"
            });
        
        }
}


module.exports =
 {
    AddPet,GetAllPet,
    GetPet,
    RemoveAllPet,
    RemovePet,
    updatePetProfile

}