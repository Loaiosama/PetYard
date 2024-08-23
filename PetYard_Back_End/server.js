
const express = require('express');
const http = require('http');
const path = require('path');
const { Server } = require('socket.io');
const bodyParser = require('body-parser');
const cors = require('cors');
const WebSocket = require('ws');


const app = require('./app');
const server = http.createServer(app);
const io = new Server(server);

// WebSocket server setup


// Import the WebSocket connection handler
// const { handleWebSocketConnection, handleChatWebSocketConnection } = require('./controllers/Location/websocketController');
// const { handleChatWebSocketConnection } = require('./controllers/Location/websocketController');
// const wss = new WebSocket.Server({ server, path: '/location' });
// wss.on('connection', handleWebSocketConnection);

// const wss = new WebSocket.Server({ server });
// wss.on('connection', handleChatWebSocketConnection);

// Register WebSocket connection handler


const pool = require('../PetYard_Back_End/db');


// WebSocket server setup
const wss = new WebSocket.Server({ server });

// Import the WebSocket connection handler
const { handleWebSocketConnection } = require('./controllers/Location/websocketController');

// Register WebSocket connection handler
wss.on('connection', handleWebSocketConnection);

app.use(express.static(path.join(__dirname, 'public')));

io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('CreateMessage', (message) => {
    console.log('Received new message:', message);
    io.emit('CreateMessage', message);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});


app.get('/api/locations', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM SittingReservation WHERE Status = $1', ['Pending']);
    console.log("kkk");
    const locations = result.rows.map(row => ({
      lat: row.location.x,
      lng: row.location.y,
      name: `Reservation ID: ${row.reserve_id}`
    }));
    res.json(locations);
  } catch (error) {
    console.error(error);
    res.status(500).json({ status: 'Fail', message: 'Internal Server Error' });
  }
});

app.use(cors());
app.use(bodyParser.json());

app.post('/api/save-location', async (req, res) => {
  const { lat, lng } = req.body;

  try {
    const query = 'INSERT INTO Location (lat, lng) VALUES ($1, $2) RETURNING *';
    const values = [lat, lng];
    const result = await pool.query(query, values);

    res.status(201).json({
      status: 'success',
      message: 'Location saved successfully',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error saving location:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to save location',
      error: err.message,
    });
  }
});

const wsServer = new WebSocket.Server({ port: 8081 }); // WebSocket server setup using 'ws' module

wsServer.on('connection', function connection(ws) {
  console.log('Client connected');

  ws.on('message', function incoming(message) {
    try {
      const data = JSON.parse(message);
      console.log(`Received Latitude: ${data.latitude}, Longitude: ${data.longitude}`);

      // Forward data to the second WebSocket server (wsServer2)
      if (wsServerTrack.clients.size > 0) {
        wsServerTrack.clients.forEach(client => {
          if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(data)); // Ensure data is stringified JSON
          }
        });
      }
    } catch (e) {
      console.error('Error parsing message:', e);
    }
  });


  ws.send('Server: Connection established');
});

const wsServerTrack = new WebSocket.Server({ port: 8082 });

wsServerTrack.on('connection', function connection(ws) {
  console.log('Client connected to wsServerTrack');

  ws.on('message', function incoming(message) {
    console.log('Received message from wsServer:', message);

  });

  ws.send('Server: Connection established');
});

console.log('WebSocket server running on ws://localhost:8081');
console.log('WebSocket server running on ws://localhost:8082');

app.use(express.static(path.join(__dirname, 'public'))); // Serve static files from 'public' directory

io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('CreateMessage', (message) => {
    console.log('Received new message:', message);
    io.emit('CreateMessage', message);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});




app.use(cors());
app.use(bodyParser.json());

const handleChatWebSocketConnectionn = (ws, serverName) => {
  ws.on('message', async (message) => {
    const data = JSON.parse(message);
    const { senderId, receiverId, text, role } = data;
    console.log(data.role);
    try {
      const client = await pool.connect();
      const insertQuery = 'INSERT INTO chatmessages (sender_id, receiver_id, message, role) VALUES ($1, $2, $3, $4)';
      const values = [senderId, receiverId, text, role];
      await client.query(insertQuery, values);
      client.release();

      // Broadcast the message to other connected clients
      broadcastMessage(serverName, data);
    } catch (error) {
      console.error('Error saving chat message to database:', error);
    }
  });

  ws.on('close', () => {
    console.log(`Client disconnected from ${serverName}`);
  });
};

// Function to broadcast messages to connected clients
const broadcastMessage = (serverName, data) => {
  const { senderId, receiverId, text } = data;
  const serverToBroadcast = serverName === 'wsServer1' ? wsServer2 : wsServer1;
  console.log(text);
  serverToBroadcast.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify({ senderId, receiverId, text }));
    }
  });
};

// Initialize WebSocket servers
const wsServer1 = new WebSocket.Server({ port: 8083 });
const wsServer2 = new WebSocket.Server({ port: 8084 });

wsServer1.on('connection', (ws) => {
  console.log('Client connected to wsServer1');
  handleChatWebSocketConnectionn(ws, 'wsServer1');
});

wsServer2.on('connection', (ws) => {
  console.log('Client connected to wsServer2');
  handleChatWebSocketConnectionn(ws, 'wsServer2');
});

console.log('WebSocket server running on ws://localhost:8081');


const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


