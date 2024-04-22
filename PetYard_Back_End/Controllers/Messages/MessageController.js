const { query } = require('express');
const pool = require("../../db");



const CreateMessage = async (req, res) => {
    const chat_id = req.params.chat_id;
    const Sender_id = req.ID;
    const { text } = req.body;

    try {
        if (!chat_id || !Sender_id || !text) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide chat_id and text"
            });
        }

        // Check if the chat with specified chat_id exists
        const queryChat = 'SELECT * FROM Chat WHERE Chat_ID = $1';
        const resultChat = await pool.query(queryChat, [chat_id]);

        if (resultChat.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Chat not found"
            });
        }

        // Insert message into Messages table
        const queryInsertMessage = 'INSERT INTO Messages (Chat_Id, Text,Sender_id) VALUES ($1, $2,$3) RETURNING *';
        const resultInsertMessage = await pool.query(queryInsertMessage, [chat_id, text,Sender_id]);

        res.status(200).json({
            status: "Success",
            message: "Message sent successfully",
            chat: resultChat.rows[0], 
            message: resultInsertMessage.rows[0] // Send inserted message details
        });

    } catch (error) {
        console.error("Error sending message:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

const GetMessages = async (req, res) => {
    const chat_id = req.params.chat_id;
    const Sender_id=req.ID;
    try {
        if (!chat_id || !Sender_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide chat_id and text"
            });
        }

        // Check if the chat with specified chat_id exists
        const queryChat = 'SELECT * FROM Chat WHERE Chat_ID = $1';
        const resultChat = await pool.query(queryChat, [chat_id]);

        if (resultChat.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Chat not found"
            });
        }

       
        const queryInsertMessage = 'SELECT * FROM Messages WHERE Chat_ID = $1 ';
        const resultInsertMessage = await pool.query(queryInsertMessage, [chat_id]);


   
        res.status(200).json({
            status: "Success",
            Data: "Chat Is Here",
            chat: resultChat.rows[0], // Send chat details
            message: resultInsertMessage.rows // Send inserted message details
        });

    } catch (error) {
        console.error("Error :", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

module.exports = {
    CreateMessage,
    GetMessages
}