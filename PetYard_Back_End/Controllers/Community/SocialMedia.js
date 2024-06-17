const { query } = require('express');
const pool = require('../../db');


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




module.exports = {
    FollowUser,
    UnfollowUsers,
    SearchUsersByName
};