const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = require('../../PetYard/PetYard_Back_End/app');
const server = http.createServer(app);
const io = new Server(server);

app.use(express.static('public')); // Serve static files from 'public' directory


io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('CreateMessage', (message) => {
    console.log('Received new message:', message);
    // Handle saving message to database, etc.
    // Broadcast the message to all connected clients
    io.emit('CreateMessage', message);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
