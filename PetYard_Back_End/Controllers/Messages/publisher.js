const amqp = require('amqplib/callback_api');
const pool = require("../../db");

const publish = async (req, res) => {
  
    
    const { Chat_ID } = req.params;
    const Sender_id = req.ID; // Assuming req.ID is set by your auth middleware
    const { message } = req.body;

    if (!message) {
        return res.status(400).json({ error: 'Message is required' });
    }
    if (!Sender_id) {
        return res.status(400).json({ error: 'Sender_id is required' });
    }
    if (!Chat_ID) {
        return res.status(400).json({ error: 'Chat_ID is required' });
    }

    try {
        const queryChat = 'SELECT * FROM Chat WHERE Chat_ID = $1';
        const resultChat = await pool.query(queryChat, [Chat_ID]);

        if (resultChat.rows.length === 0) {
            return res.status(404).json({
                status: "Fail",
                message: "Chat not found"
            });
        }

        const queueName = `${Chat_ID}`;

        amqp.connect('amqp://localhost', (err, connection) => {
            if (err) {
                console.error('Failed to connect to RabbitMQ:', err);
                return res.status(500).json({ error: 'Failed to connect to RabbitMQ' });
            }
            connection.createChannel(async (err, channel) => {
                if (err) {
                    console.error('Failed to create channel:', err);
                    connection.close();
                    return res.status(500).json({ error: 'Failed to create channel' });
                }
                try {
                    channel.assertQueue(queueName, { durable: false });
                    channel.sendToQueue(queueName, Buffer.from(message));
                    console.log(`Message sent: ${message}`);

                    const queryInsertMessage = 'INSERT INTO Messages (Chat_Id, Text, Sender_id) VALUES ($1, $2, $3) RETURNING *';
                    const resultInsertMessage = await pool.query(queryInsertMessage, [Chat_ID, message, Sender_id]);

                    res.status(200).json({
                        status: "Success",
                        message: "Message sent successfully",
                        chat: resultChat.rows[0],
                        message: resultInsertMessage.rows[0] // Send inserted message details
                    });
                } catch (error) {
                    console.error('Error inserting message into database:', error);
                    res.status(500).json({ error: 'Internal server error' });
                } finally {
                    setTimeout(() => {
                        connection.close();
                    }, 1000);
                }
            });
        });
    } catch (error) {
        console.error("Error processing request:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

module.exports = {
    publish
};
