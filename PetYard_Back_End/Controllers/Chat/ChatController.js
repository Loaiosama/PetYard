const { query } = require('express');
const pool = require('../../db');

const CreateChat = async (req, res) => {
    const First_id = req.ID;
    const Second_id = req.params.Second_id;

    try {
        if (!First_id || !Second_id) {
            return res.status(400).json({
                Message: 'Please Provide All Information'
            });
        }

        const chatQuery = 'SELECT * FROM Chat WHERE (Members[1]=$1 AND Members[2]=$2) AND (Owner_ID=$1 AND Provider_ID=$2)';
        const chatResult = await pool.query(chatQuery, [First_id, Second_id]);

        if (chatResult.rows.length > 0) {
            return res.status(200).json({
                data: chatResult.rows
            });
        }

        const client = await pool.connect();
        const createChatQuery = 'INSERT INTO Chat (Members, Provider_ID, Owner_ID) VALUES ($1, $2, $3) RETURNING *';
        const newChat = await client.query(createChatQuery, [[First_id, Second_id], Second_id, First_id]);
        client.release();

        res.status(200).json({
            data: newChat.rows
        });

    } catch (error) {
        console.error("Error creating chat:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};


const FindUserChats = async (req, res) => {
    const User_id = req.ID;

    try {
        if (!User_id) {
            return res.status(400).json({
                Message: 'Please Provide User ID'
            });
        }

        const chatsQuery = 'SELECT * FROM chat WHERE $1 = ANY(members)';
        const chatsResult = await pool.query(chatsQuery, [User_id]);

        res.status(200).json({
            data: chatsResult.rows
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};


const FindChat = async (req, res) => {
    const Second_id = req.params.Second_id;
    const First_id=req.params.First_id;

    try {
        if (!Second_id || !First_id ) {
            return res.status(400).json({
                Message: 'Please Provide All Information'
            });
        }

         const chatQuery = 'SELECT * FROM Chat WHERE (Members[1]=$1 AND Members[2]=$2) AND (Owner_ID=$1 AND Provider_ID=$2)';
         const chatResult = await pool.query(chatQuery, [First_id, Second_id]);


        res.status(200).json({
            data: chatResult.rows
        });

    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};


module.exports = {
    CreateChat,
    FindUserChats,
    FindChat
};