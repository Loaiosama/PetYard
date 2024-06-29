const pool = require('../../db');
const clients = {};

exports.handleWebSocketConnection = (ws) => {
  ws.on('message', async (message) => {
    const data = JSON.parse(message);
    const { serviceProviderId, latitude, longitude, petOwnerId, role } = data;

    if (role === 'petOwner') {
      clients[petOwnerId] = ws;
      return;
    }

    if (role === 'serviceProvider') {
      try {
        const client = await pool.connect();
        const insertQuery = 'INSERT INTO LocationUpdates (service_provider_id, latitude, longitude) VALUES ($1, $2, $3)';
        await client.query(insertQuery, [serviceProviderId, latitude, longitude]);

        const geofenceQuery = 'SELECT center_latitude, center_longitude, radius FROM Geofence WHERE pet_owner_id = $1';
        const { rows } = await client.query(geofenceQuery, [petOwnerId]);
        const { center_latitude, center_longitude, radius } = rows[0];

        const distance = calculateDistance(center_latitude, center_longitude, latitude, longitude);
        if (distance > radius) {
          ws.send(JSON.stringify({ message: 'You are outside the allowed area!' }));
          if (clients[petOwnerId]) {
            clients[petOwnerId].send(JSON.stringify({ message: 'The service provider is outside the allowed area!' }));
          }
        }

        if (clients[petOwnerId]) {
          clients[petOwnerId].send(JSON.stringify({ latitude, longitude }));
        }

        client.release();
      } catch (error) {
        console.error('Error processing location update', error);
      }
    }
  });

  ws.on('close', () => {
    for (let key in clients) {
      if (clients[key] === ws) {
        delete clients[key];
      }
    }
  });
};

function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Radius of the Earth in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in km
}

