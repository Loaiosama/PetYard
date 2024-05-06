const pool = require('../../db');
const multer =require('multer');

const sharp = require('sharp');




const multerStorage=multer.memoryStorage();

const multerFilter=(req,file,cb)=>{
    if(file.mimetype.startsWith('image')){
        cb(null,true);
    }
    else{
        cb("Not an image! please upload only images.",false)
    }
}


const upload=multer({

    storage:multerStorage,
    fileFilter:multerFilter
});

const uploadpetphoto=upload.single('Image');



const resizePhoto=(req,res,next)=>{

    if(!req.file) return next();
    req.file.filename=`Pet-${req.ID}-${Date.now()}.jpeg`;

    sharp(req.file.buffer).resize(500,500).toFormat('jpeg').jpeg({quality:90}).toFile(`public/img/Pets/${req.file.filename}`);
    next();
}


const AddPet = async(req,res)=>
{
    const {Type,Name,Gender,Breed,Date_of_birth,Adoption_Date,Weight,Bio}=req.body;
    const owner_id = req.ID; 
    let Image = req.file ? req.file.filename : 'default.png';
    try 
    {
        if (!Type || !Name || !Gender || !Breed || !Date_of_birth || !Adoption_Date || !Image || !Weight || !Bio) 
        {
            return res.status(400).json({
                status: "Fail",
                message: "Please Fill All Information"
            });
        }

        const addPetQuery = 'INSERT INTO Pet (Type, Name, Gender, Breed, Date_of_birth, Adoption_Date, Image, Weight ,Owner_Id,Bio) VALUES ($1, $2, $3, $4, $5, $6, $7,$8,$9,$10)';
        await pool.query(addPetQuery, [Type, Name, Gender, Breed, Date_of_birth, Adoption_Date, Image, Weight,owner_id,Bio]);
        
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
    
    const {Pet_Id}=req.params;
    const owner_id = req.ID; 
    const {Name,Gender,Breed,Date_of_birth,Adoption_Date,Weight,Bio} = req.body;
    let Image = req.file ? req.file.filename : 'default.png';


    try {
        if(!Pet_Id || !owner_id)
        {
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

        const updateQuery = 'UPDATE Pet SET  Name=$1,Gender=$2,Breed=$3,Date_of_birth=$4,Adoption_Date=$5,Weight=$6,Image=$7,Bio=$8 WHERE Pet_Id=$9 AND owner_id=$10';
        const UpdatePet =await pool.query(updateQuery ,[Name,Gender,Breed,Date_of_birth,Adoption_Date,Weight,Image,Bio,Pet_Id,owner_id]);

        res.status(200).json({
            status: "Success",
            message: " update successfully"
        }); 

        }catch (error){
            console.error("Error:", error);
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
    updatePetProfile,
    uploadpetphoto,
    resizePhoto

}