const pool = require('../../db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const axios = require('axios');
const multer = require('multer');
const sharp = require('sharp');
const saltRounds = 10;
const crypto = require('crypto');//reset pass - forget pass
const Model = require('./../../Models/UserModel');
const sendemail = require("./../../Utils/email");

// const getAllChatsForProvider = async (req, res) => {
//     const providerId = req.params.providerId; // Assuming providerId is passed as a parameter

//     try {
//         const client = await pool.connect();
//         const query = `
//         SELECT DISTINCT ON (sender_id, receiver_id)
//           sender_id,
//           receiver_id,
//           CASE
//             WHEN sender_id = $1 THEN 'owner'
//             ELSE 'provider'
//           END AS role
//         FROM chatmessages
//         WHERE sender_id = $1 OR receiver_id = $1
//         ORDER BY sender_id, receiver_id, timestamp DESC;
//       `;
//         const result = await client.query(query, [providerId]);
//         client.release();

//         res.status(200).json({
//             "Status": "Success",
//             "data": result.rows,
//         });
//     } catch (error) {
//         console.error('Error fetching all chats for provider:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// };




// const getAllChatsForProvider = async (req, res) => {
//     const providerIdFromToken = req.ID; // Assuming 'id' is the field in the token that stores provider ID

//     try {
//         const client = await pool.connect();
//         const query = `
//             SELECT DISTINCT ON (sender_id, receiver_id)
//               sender_id,
//               receiver_id,
//               CASE
//                 WHEN sender_id = $1 THEN 'owner'
//                 ELSE 'provider'
//               END AS role
//             FROM chatmessages
//             WHERE sender_id = $1 OR receiver_id = $1
//             ORDER BY sender_id, receiver_id, timestamp DESC;
//         `;
//         const result = await client.query(query, [providerIdFromToken]);
//         client.release();

//         res.status(200).json({
//             "Status": "Success",
//             "data": result.rows,
//         });
//     } catch (error) {
//         console.error('Error fetching all chats for provider:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// };


// const getAllChatsForProvider = async (req, res) => {
//     const providerIdFromToken = req.ID; // Assuming 'ID' is the field in the token that stores provider ID

//     try {
//         const client = await pool.connect();
//         const query = `
//             SELECT DISTINCT ON (sender_id, receiver_id)
//               sender_id,
//               receiver_id,
//               CASE
//                 WHEN sender_id = $1 THEN 'serviceProvider'
//                 ELSE 'petOwner'
//               END AS role
//             FROM chatmessages
//             WHERE sender_id = $1 OR receiver_id = $1
//             ORDER BY sender_id, receiver_id, timestamp DESC;
//         `;
//         const result = await client.query(query, [providerIdFromToken]);
//         client.release();

//         res.status(200).json({
//             "Status": "Success",
//             "data": result.rows,
//         });
//     } catch (error) {
//         console.error('Error fetching all chats for provider:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// };
const getAllChatsForProvider = async (req, res) => {
    const providerIdFromToken = req.ID; // Assuming 'ID' is the field in the token that stores provider ID

    try {
        const client = await pool.connect();
        const query = `
            SELECT DISTINCT ON (cm.sender_id, cm.receiver_id)
              cm.sender_id,
              cm.receiver_id,
              'petOwner' AS role,
              po.First_name || ' ' || po.Last_name AS owner_name,
              po.Image AS owner_image,
              sp.UserName AS provider_name,
              sp.Image AS provider_image,
              cm.message AS last_message,
              cm.timestamp AS last_message_timestamp
            FROM chatmessages cm
            LEFT JOIN Petowner po ON cm.sender_id = po.Owner_Id
            LEFT JOIN ServiceProvider sp ON cm.receiver_id = sp.Provider_Id
            WHERE cm.receiver_id = $1
              AND cm.message IS NOT NULL
              AND cm.message != ''
            ORDER BY cm.sender_id, cm.receiver_id, cm.timestamp DESC;
        `;
        const result = await client.query(query, [providerIdFromToken]);
        client.release();

        // Format the results to include only necessary information
        const formattedResult = result.rows.map(row => ({
            sender_id: row.sender_id,
            receiver_id: row.receiver_id,
            role: row.role,
            name: row.owner_name,
            image: row.owner_image,
            last_message: row.last_message,
            last_message_timestamp: row.last_message_timestamp,
        }));

        res.status(200).json({
            "Status": "Success",
            "data": formattedResult,
        });
    } catch (error) {
        console.error('Error fetching all chats for provider:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};


// const getAllChatsForProvider = async (req, res) => {
//     const providerIdFromToken = req.ID; // Assuming 'ID' is the field in the token that stores provider ID

//     try {
//         const client = await pool.connect();
//         const query = `
//             SELECT DISTINCT ON (sender_id, receiver_id)
//               sender_id,
//               receiver_id,
//               CASE
//                 WHEN sender_id = $1 THEN 'serviceProvider'
//                 ELSE 'petOwner'
//               END AS role,
//               CASE
//                 WHEN sender_id = $1 THEN (
//                     SELECT CONCAT(First_name, ' ', Last_name) AS name
//                     FROM Petowner
//                     WHERE Owner_Id = receiver_id
//                 )
//                 ELSE (
//                     SELECT UserName AS name
//                     FROM ServiceProvider
//                     WHERE Provider_Id = sender_id
//                 )
//               END AS name,
//               CASE
//                 WHEN sender_id = $1 THEN (
//                     SELECT Image
//                     FROM Petowner
//                     WHERE Owner_Id = receiver_id
//                 )
//                 ELSE (
//                     SELECT Image
//                     FROM ServiceProvider
//                     WHERE Provider_Id = sender_id
//                 )
//               END AS image
//             FROM chatmessages
//             WHERE sender_id = $1 OR receiver_id = $1
//             ORDER BY sender_id, receiver_id, timestamp DESC;
//         `;
//         const result = await client.query(query, [providerIdFromToken]);
//         client.release();

//         res.status(200).json({
//             "Status": "Success",
//             "data": result.rows,
//         });
//     } catch (error) {
//         console.error('Error fetching all chats for provider:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// };



// const getChatHistoryForProvider = async (req, res) => {
//     const providerIdFromToken = req.ID; // Assuming 'id' is the field in the token that stores provider ID
//     const { chatPartnerId } = req.params; // The other person's ID in the chat

//     try {
//         const client = await pool.connect();
//         const query = `
//             SELECT *
//             FROM chatmessages
//             WHERE (sender_id = $1 AND receiver_id = $2) OR (sender_id = $2 AND receiver_id = $1)
//             ORDER BY timestamp ASC;
//         `;
//         const result = await client.query(query, [providerIdFromToken, chatPartnerId]);
//         client.release();

//         res.status(200).json({
//             "Status": "Success",
//             "data": result.rows,
//         });
//     } catch (error) {
//         console.error('Error fetching chat history for provider:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// };


const getChatMessagesHistory = async (req, res) => {
    const { providerId, ownerId } = req.params;

    try {
        const client = await pool.connect();
        const query = `
        SELECT sender_id, receiver_id, message, timestamp, role
        FROM chatmessages
        WHERE (sender_id = $1 AND receiver_id = $2)
           OR (sender_id = $2 AND receiver_id = $1)
        ORDER BY timestamp ASC;
      `;
        const result = await client.query(query, [providerId, ownerId]);
        client.release();


        res.status(200).json({
            "Status": "Success",
            "data": result.rows,
        });
    } catch (error) {
        console.error('Error fetching chat messages history:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};



// const getAllChatsForOwner = async (req, res) => {
//     const ownerIdFromToken = req.ID; // Assuming 'id' is the field in the token that stores owner ID

//     try {
//         const client = await pool.connect();
//         const query = `
//             SELECT DISTINCT ON (sender_id, receiver_id)
//               sender_id,
//               receiver_id,
//               CASE
//                 WHEN sender_id = $1 THEN 'provider'
//                 ELSE 'owner'
//               END AS role
//             FROM chatmessages
//             WHERE sender_id = $1 OR receiver_id = $1
//             ORDER BY sender_id, receiver_id, timestamp DESC;
//         `;
//         const result = await client.query(query, [ownerIdFromToken]);
//         client.release();

//         res.status(200).json({
//             "Status": "Success",
//             "data": result.rows,
//         });
//     } catch (error) {
//         console.error('Error fetching all chats for owner:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// };

const getAllChatsForOwner = async (req, res) => {
    const ownerIdFromToken = req.ID; // Assuming 'ID' is the field in the token that stores owner ID

    try {
        const client = await pool.connect();
        const query = `
            SELECT DISTINCT ON (cm.sender_id, cm.receiver_id)
              cm.sender_id,
              cm.receiver_id,
              'serviceProvider' AS role,
              sp.UserName AS provider_name,
              sp.Image AS provider_image,
              po.First_name || ' ' || po.Last_name AS owner_name,
              po.Image AS owner_image,
              cm.message AS last_message,
              cm.timestamp AS last_message_timestamp
            FROM chatmessages cm
            LEFT JOIN ServiceProvider sp ON cm.receiver_id = sp.Provider_Id
            LEFT JOIN PetOwner po ON cm.sender_id = po.Owner_Id
            WHERE cm.sender_id = $1
              AND cm.message IS NOT NULL
              AND cm.message != ''
            ORDER BY cm.sender_id, cm.receiver_id, cm.timestamp DESC;
        `;
        const result = await client.query(query, [ownerIdFromToken]);
        client.release();

        // Format the results to include only necessary information
        const formattedResult = result.rows.map(row => ({
            sender_id: row.sender_id,
            receiver_id: row.receiver_id,
            role: row.role,
            name: row.provider_name,
            image: row.provider_image,
            last_message: row.last_message,
            last_message_timestamp: row.last_message_timestamp,
        }));

        res.status(200).json({
            "Status": "Success",
            "data": formattedResult,
        });
    } catch (error) {
        console.error('Error fetching all chats for owner:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};



// const getAllChatsForOwner = async (req, res) => {
//     const ownerIdFromToken = req.ID; // Assuming 'id' is the field in the token that stores owner ID

//     try {
//         const client = await pool.connect();
//         const query = `
//             SELECT DISTINCT ON (sender_id, receiver_id)
//                 cm.sender_id,
//                 cm.receiver_id,
//                 'provider' AS role,
//                 sp.UserName AS name,
//                 sp.Image AS image,
//                 cm.message,
//                 cm.timestamp
//             FROM chatmessages cm
//             INNER JOIN ServiceProvider sp ON cm.sender_id = sp.Provider_Id
//             WHERE cm.receiver_id = $1
//               AND cm.message IS NOT NULL
//               AND cm.message != ''
//             ORDER BY cm.sender_id, cm.receiver_id, cm.timestamp DESC;
//         `;
//         const result = await client.query(query, [ownerIdFromToken]);
//         client.release();

//         res.status(200).json({
//             "Status": "Success",
//             "data": result.rows,
//         });
//     } catch (error) {
//         console.error('Error fetching all chats for owner:', error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// };



const getChatHistoryForOwner = async (req, res) => {
    const ownerId = req.ID; // Assuming 'id' is the field in the token that stores owner ID
    console.log(ownerId);
    const { providerId } = req.params;

    try {
        const client = await pool.connect();
        const query = `
            SELECT *
            FROM chatmessages
            WHERE (sender_id = $1 AND receiver_id = $2) OR (sender_id = $2 AND receiver_id = $1)
            ORDER BY timestamp ASC;
        `;
        const result = await client.query(query, [ownerId, providerId]);
        client.release();

        res.status(200).json({
            "Status": "Success",
            "data": result.rows,
        });
    } catch (error) {
        console.error('Error fetching chat history for owner:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};


module.exports = {
    getAllChatsForProvider,
    getChatMessagesHistory,
    getAllChatsForOwner,
    getChatHistoryForOwner

};