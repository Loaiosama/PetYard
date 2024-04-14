const { query } = require('express');
const pool = require('../db');


const SendMessage = async (req, res) => {
    const chat_id = req.params.chat_id;
    const { text } = req.body;

    try {
        if (!chat_id || !text) {
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
        const queryInsertMessage = 'INSERT INTO Messages (Chat_Id, Text) VALUES ($1, $2) RETURNING *';
        const resultInsertMessage = await pool.query(queryInsertMessage, [chat_id, text]);

        res.status(200).json({
            status: "Success",
            message: "Message sent successfully",
            chat: resultChat.rows[0], // Send chat details
            message: resultInsertMessage.rows[0] // Send inserted message details
        });

    } catch (error) {
        console.error("Error sending message:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

const GetMessage = async (req, res) => {
    const chat_id = req.params.chat_id;
    try {
        if (!chat_id ) {
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
        const queryInsertMessage = 'INSERT INTO Messages (Chat_Id, Text) VALUES ($1, $2) RETURNING *';
        const resultInsertMessage = await pool.query(queryInsertMessage, [chat_id, text]);

        res.status(200).json({
            status: "Success",
            message: "Message sent successfully",
            chat: resultChat.rows[0], // Send chat details
            message: resultInsertMessage.rows[0] // Send inserted message details
        });

    } catch (error) {
        console.error("Error sending message:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

module.exports = {
    SendMessage
}