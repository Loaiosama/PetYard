const amqp = require('amqplib/callback_api');
const express = require('express');
const app = express();
const pool = require("../../db");



const subscribe = async (req, res) => {

    const Chat_ID = req.params.Chat_ID;
    const Sender_id=req.ID;
  
     if (!Chat_ID || !Sender_id) {
            return res.status(400).json({
                status: "Fail",
                message: "Please provide chat_id and text"
            });
        }

     const queueName = `${Chat_ID}`;

    amqp.connect('amqp://localhost', (err, connection) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Failed to connect to RabbitMQ' });
        }
        connection.createChannel((err, channel) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: 'Failed to create channel' });
            }
            channel.assertQueue(queueName, { durable: false });

            console.log(`Waiting for messages in ${queueName}. To exit press CTRL+C`);

            channel.consume(queueName, (msg) => {
                if (msg !== null) {
                    console.log(`Received: ${msg.content.toString()}`);
    
                    channel.ack(msg);
                }
            });

            res.status(200).json({ message: 'Subscription started' });
        });
    });
};

module.exports = {
    subscribe
}
