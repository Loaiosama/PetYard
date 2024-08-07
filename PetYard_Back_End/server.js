// const express = require('express');
// const http = require('http');
// const path = require('path');
// const { Server } = require('socket.io');
// const bodyParser = require('body-parser');
// const cors = require('cors');
// const WebSocket = require('ws');


// const app = require('./app');
// const server = http.createServer(app);
// const io = new Server(server);

// // WebSocket server setup
// const wss = new WebSocket.Server({ server });

// // Import the WebSocket connection handler
// const { handleWebSocketConnection } = require('./controllers/Location/websocketController');

// // Register WebSocket connection handler
// wss.on('connection', handleWebSocketConnection);

// app.use(express.static(path.join(__dirname, 'public'))); // Serve static files from 'public' directory

// io.on('connection', (socket) => {
//   console.log('A user connected');

//   socket.on('CreateMessage', (message) => {
//     console.log('Received new message:', message);
//     io.emit('CreateMessage', message);
//   });

//   socket.on('disconnect', () => {
//     console.log('User disconnected');
//   });
// });


// const pool = require('../PetYard_Back_End/db');



// app.get('/api/locations', async (req, res) => {
//   try {
//       const result = await pool.query('SELECT * FROM SittingReservation WHERE Status = $1', ['Pending']);
//       console.log("kkk");
//       const locations = result.rows.map(row => ({
//           lat: row.location.x,
//           lng: row.location.y,
//           name: `Reservation ID: ${row.reserve_id}`
//       }));
//       res.json(locations);
//   } catch (error) {
//       console.error(error);
//       res.status(500).json({ status: 'Fail', message: 'Internal Server Error' });
//   }

// })


// app.use(cors());
// app.use(bodyParser.json());

// app.post('/api/save-location', async (req, res) => {
//   const { lat, lng } = req.body;

//   try {
//       const query = 'INSERT INTO Location (lat, lng) VALUES ($1, $2) RETURNING *';
//       const values = [lat, lng];
//       const result = await pool.query(query, values);

//       res.status(201).json({
//           status: 'success',
//           message: 'Location saved successfully',
//           data: result.rows[0],
//       });
//   } catch (err) {
//       console.error('Error saving location:', err);
//       res.status(500).json({
//           status: 'error',
//           message: 'Failed to save location',
//           error: err.message,
//       });
//   }
// });







// const ws = new WebSocket.Server({ port: 8081 });

// ws.on('connection', function connection(ws) {
//     console.log('Client connected');

//     // Send random location updates every 2 seconds
//     const interval = setInterval(() => {
//         const lat = 30.0444 + (Math.random() - 0.5) * 0.01;
//         const lng = 31.2357 + (Math.random() - 0.5) * 0.01;
//         const data = JSON.stringify({ lat, lng });
//         ws.send(data);
//     }, 2000);

//     ws.on('close', () => {
//         console.log('Client disconnected');
//         clearInterval(interval);
//     });
// });

// console.log('WebSocket server running on ws://localhost:8081');







// const PORT = process.env.PORT || 3000;
// server.listen(PORT, () => {
//   console.log(`Server is running on port ${PORT}`);
// });


const express = require('express');
const http = require('http');
const path = require('path');
const { Server } = require('socket.io');
const bodyParser = require('body-parser');
const cors = require('cors');
const WebSocket = require('ws'); // Using 'ws' npm module for WebSocket server

const app = require('./app');
const server = http.createServer(app);
const io = new Server(server);

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

const pool = require('../PetYard_Back_End/db');

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
      if (wsServer2.clients.size > 0) {
        wsServer2.clients.forEach(client => {
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

const wsServer2 = new WebSocket.Server({ port: 8082 }); 

wsServer2.on('connection', function connection(ws) {
  console.log('Client connected to wsServer2');
  
  ws.on('message', function incoming(message) {
    console.log('Received message from wsServer:', message);
    
  });

  ws.send('Server: Connection established');
});

console.log('WebSocket server running on ws://localhost:8081');
console.log('WebSocket server running on ws://localhost:8082');

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
