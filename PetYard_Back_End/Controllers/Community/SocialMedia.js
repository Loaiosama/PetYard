const { query } = require('express');
const pool = require('../../db');
const multer =require('multer');
const sharp = require('sharp');
const { use } = require('passport');




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

const uploadphoto=upload.single('Image');

const resizePhoto=(req,res,next)=>{

    if(!req.file) return next();

    req.file.filename=`Posts-${req.ID}-${Date.now()}.jpeg`;

    sharp(req.file.buffer).resize(500,500).toFormat('jpeg').jpeg({quality:90}).toFile(`public/img/Posts/${req.file.filename}`);
    next();
}







// Follow a user
const FollowUser = async (req, res) => {
    const id = req.ID;
    const { type, user_type } = req.body;
    const { user_id } = req.params;
    const userIdNumber = Number(user_id); // Convert user_id to a number

    try {
        if (!id || !user_id || !type || !user_type) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all information."
            });
        }

    
        if (id === userIdNumber && type === user_type) {
            console.log("You can't follow yourself!");
            return res.status(403).json({
                status: "Fail",
                message: "You can't follow yourself!"
            });
        }

        let resultFollower, resultFollowee;

        // Verify the existence of the follower
        if (type === "Petowner") {
            resultFollower = await pool.query('SELECT * FROM Petowner WHERE Owner_Id = $1', [id]);
        } else if (type === "ServiceProvider") {
            resultFollower = await pool.query('SELECT * FROM ServiceProvider WHERE Provider_Id = $1', [id]);
        } else {
            return res.status(400).json({
                status: "Fail",
                message: "Invalid follower type specified."
            });
        }

        if (resultFollower.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Follower not found"
            });
        }
       

        // Verify the existence of the followee
        if (user_type === "Petowner") {
            resultFollowee = await pool.query('SELECT * FROM Petowner WHERE Owner_Id = $1', [userIdNumber]);
          
        } else if (user_type === "ServiceProvider") {
            resultFollowee = await pool.query('SELECT * FROM ServiceProvider WHERE Provider_Id = $1', [userIdNumber]);
        } else {
            return res.status(400).json({
                status: "Fail",
                message: "Invalid followee type specified."
            });
        }

        if (resultFollowee.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Followee not found"
            });
        }

        // Check if the follow relationship already exists
        const checkQuery = 'SELECT * FROM Followers WHERE Follower_ID = $1 AND Follower_Type = $2 AND Followee_ID = $3 AND Followee_Type = $4';
        const existingFollow = await pool.query(checkQuery, [id, type, userIdNumber, user_type]);

        if (existingFollow.rows.length > 0) {
            return res.status(409).json({
                status: "Fail",
                message: "You are already following this user"
            });
        }

        // Insert the follow relationship
        const insertQuery = 'INSERT INTO Followers (Follower_ID, Follower_Type, Followee_ID, Followee_Type) VALUES ($1, $2, $3, $4) RETURNING *';
        const newFollow = await pool.query(insertQuery, [id, type, userIdNumber, user_type]);

        res.status(201).json({
            status: "Success",
            message: "Successfully followed",
            data: newFollow.rows[0]
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};
//unfollow a user
const UnfollowUsers = async (req, res) => {
    const id = req.ID;
    const { type, user_type } = req.body;
    const { user_id } = req.params;
    const userIdNumber = Number(user_id); // Convert user_id to a number

    try {
        if (!id || !user_id || !type || !user_type) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all information."
            });
        }

        if (id === userIdNumber && type === user_type) {
            return res.status(403).json({
                status: "Fail",
                message: "You can't unfollow yourself!"
            });
        }

        let resultFollower, resultFollowee;

        // Verify the existence of the follower
        if (type === "Petowner") {
            resultFollower = await pool.query('SELECT * FROM Petowner WHERE Owner_Id = $1', [id]);
        } else if (type === "ServiceProvider") {
            resultFollower = await pool.query('SELECT * FROM ServiceProvider WHERE Provider_Id = $1', [id]);
        } else {
            return res.status(400).json({
                status: "Fail",
                message: "Invalid follower type specified."
            });
        }

        if (resultFollower.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Follower not found"
            });
        }

        // Verify the existence of the followee
        if (user_type === "Petowner") {
            resultFollowee = await pool.query('SELECT * FROM Petowner WHERE Owner_Id = $1', [userIdNumber]);
        } else if (user_type === "ServiceProvider") {
            resultFollowee = await pool.query('SELECT * FROM ServiceProvider WHERE Provider_Id = $1', [userIdNumber]);
        } else {
            return res.status(400).json({
                status: "Fail",
                message: "Invalid followee type specified."
            });
        }

        if (resultFollowee.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Followee not found"
            });
        }

        // Delete the follow relationship if it exists
        const deleteQuery = 'DELETE FROM Followers WHERE Follower_ID = $1 AND Follower_Type = $2 AND Followee_ID = $3 AND Followee_Type = $4 RETURNING *';
        const unfollowResult = await pool.query(deleteQuery, [id, type, userIdNumber, user_type]);

        if (unfollowResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Follow relationship not found"
            });
        }

        res.status(200).json({
            status: "Success",
            message: "Successfully unfollowed",
            data: unfollowResult.rows[0]
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

const SearchUsersByName = async (req, res) => {
    const { name } = req.params;

    try {
        if (!name) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide a valid name"
            });
        }

        // Example query to search for Petowners by name
        const petownerQuery = `SELECT * FROM Petowner WHERE LOWER(First_name) LIKE LOWER($1) OR LOWER(Last_name) LIKE LOWER($1)`;
        const petownerResult = await pool.query(petownerQuery, [`%${name}%`]);

        // Example query to search for ServiceProviders by name
        const serviceProviderQuery = `SELECT * FROM ServiceProvider WHERE LOWER(UserName) LIKE LOWER($1)`;
        const serviceProviderResult = await pool.query(serviceProviderQuery, [`%${name}%`]);

        const results = {
            petowners: petownerResult.rows,
            serviceProviders: serviceProviderResult.rows
        };

        res.status(200).json({
            status: "Success",
            message: "Search results",
            data: results
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

//Create posts
const CreatePosts = async (req, res) => {
    const id = req.ID;
    const { description, user_type } = req.body;
    let Image = req.file.filename;

     
    try {
        if (!id || !user_type || !description || !Image) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all information"
            });
        }

        let result;
        if (user_type === "Petowner") {
            result = await pool.query('SELECT * FROM Petowner WHERE Owner_Id = $1', [id]);
        } else if (user_type === "ServiceProvider") {
            result = await pool.query('SELECT * FROM ServiceProvider WHERE Provider_Id = $1', [id]);
        } else {
            return res.status(400).json({
                status: "Fail",
                message: "Invalid user type specified."
            });
        }

        if (result.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "User not found"
            });
        }

        const insertQuery = 'INSERT INTO Posts (user_id, user_type, description, image) VALUES ($1, $2, $3, $4) RETURNING *';
        const newPost = await pool.query(insertQuery, [id, user_type, description, Image]);

        res.status(201).json({
            status: "Success",
            message: "Post successfully created",
            data: newPost.rows[0]
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

//update posts
const updatePost =async (req,res)=>{
    const id =req.ID;
    const {description,user_type}=req.body;
    const {post_id}=req.params;
    let Image = req.file.filename;
    

    try {


        if (!id || !user_type || !description || !Image || !post_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all information"
            });
        }


        const selectQuery = 'SELECT * FROM Posts WHERE id = $1 AND user_id = $2 AND user_type = $3';
        const selectResult = await pool.query(selectQuery, [post_id, id, user_type]);

        if (selectResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Post not found or you do not have permission to update this post"
            });
        }

        const updateQuery = 'UPDATE Posts SET  description=$1,Image=$2 WHERE id=$3';
        const UpdatePet =await pool.query(updateQuery ,[description,Image,post_id]);

        res.status(200).json({
            status: "Success",
            message: " update successfully",
        }); 



        
    } catch (error) {

        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
        
    }
    
};

//delete posts
const DeletePost=async(req,res)=>{
    const id =req.ID;
    const {post_id}=req.params;
    try {
        if(!id || !post_id){
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all information"
            });
        }
        const selectQuery = 'SELECT * FROM Posts WHERE id = $1 ';
        const selectResult = await pool.query(selectQuery, [post_id]);

        if (selectResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Post not found or you do not have permission to update this post"
            });
        }
            
        const deleteQuery =await pool.query('DELETE FROM Posts WHERE id = $1',[post_id]); 
        res.status(200).json({
            status: "Success",
            message: "Post deleted successfully"
        });
        
    } catch (error) {

        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
        
    }


};
//Like Or Dislike  posts
const LikeOrDislikePost = async (req, res) => {
    const id = req.ID; // Assuming this is the authenticated user's ID
    const { user_type } = req.body; // Assuming user_type is provided in the request body
    const { post_id } = req.params; // Assuming post_id is provided as a route parameter

    try {
        // Check if any required information is missing
        if (!id || !post_id || !user_type) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all required information"
            });
        }

        // Fetch the post including its likes JSONB
        const selectQuery = 'SELECT * FROM Posts WHERE id = $1';
        const selectResult = await pool.query(selectQuery, [post_id]);

        // Check if the post exists
        if (selectResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Post not found"
            });
        }

        const post = selectResult.rows[0];
        let updateQuery, updateResult;

        // Initialize the likes array as an empty object if it's null or undefined
        const likesObject = post.likes || {};

        // Check if the likeInfo exists in the likes array
        const likeKey = `${id}_${user_type}`;
        const likeExists = likesObject.hasOwnProperty(likeKey);

        if (likeExists) {
            // If the user has already liked the post, remove the like (dislike)
            delete likesObject[likeKey];
        } else {
            // If the user hasn't liked the post yet, add the like
            likesObject[likeKey] = true;
        }

        // Update the likes field in the database
        updateQuery = 'UPDATE Posts SET likes = $1 WHERE id = $2 RETURNING *';
        updateResult = await pool.query(updateQuery, [likesObject, post_id]);

        res.status(200).json({
            status: "Success",
            message: likeExists ? "Post disliked successfully" : "Post liked successfully",
            data: updateResult.rows[0]
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};





//get post
const getpost = async (req, res) => {
    const id = req.ID;
    const { post_id } = req.params;

    try {
        if (!id || !post_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide all required information"
            });
        }

        const selectQuery = 'SELECT * FROM Posts WHERE id = $1';
        const selectResult = await pool.query(selectQuery, [post_id]);

        if (selectResult.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Post not found"
            });
        }

        const post = selectResult.rows[0];

        res.status(200).json({
            status: "Success",
            data: post
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};

//get timeline posts
const getTimelinePosts = async (req, res) => {
    const id = req.ID;
    const { user_type } = req.body; // Assuming user_type is in the body
    const { page = 1, limit = 10 } = req.query; // Default to page 1 and limit 10

    try {
        if (!id || !user_type) {
            return res.status(400).json({
                status: "Fail",
                message: "User ID and User Type are required"
            });
        }

        const offset = (page - 1) * limit;

        // Fetch total number of posts for pagination
        const countQuery = `
            SELECT COUNT(*) FROM Posts 
            WHERE user_id = $1 
            OR (user_id, user_type) IN (
                SELECT Followee_ID, Followee_Type 
                FROM Followers 
                WHERE Follower_ID = $1 AND Follower_Type = $2
            )
        `;
        const countResult = await pool.query(countQuery, [id, user_type]);
        const total = parseInt(countResult.rows[0].count, 10);

        // Fetch posts for the user's timeline
        const selectQuery = `
            SELECT * FROM Posts 
            WHERE user_id = $1 
            OR (user_id, user_type) IN (
                SELECT Followee_ID, Followee_Type 
                FROM Followers 
                WHERE Follower_ID = $1 AND Follower_Type = $2
            )
            ORDER BY created_at DESC
            LIMIT $3 OFFSET $4
        `;
        const selectResult = await pool.query(selectQuery, [id, user_type, limit, offset]);

        const posts = selectResult.rows;

        res.status(200).json({
            status: "Success",
            data: posts,
            page: parseInt(page),
            limit: parseInt(limit),
            total
        });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({
            status: "Fail",
            message: "Internal server error"
        });
    }
};









module.exports = {
    FollowUser,
    UnfollowUsers,
    SearchUsersByName,
    uploadphoto,
    resizePhoto,
    CreatePosts,
    updatePost,
    DeletePost,
    LikeOrDislikePost,
    getpost,
    getTimelinePosts
};