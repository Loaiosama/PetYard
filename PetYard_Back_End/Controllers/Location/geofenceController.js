const pool = require('../../db');

const setGeofence = async (req, res) => {
  const { petOwnerId, centerLatitude, centerLongitude, radius } = req.body;

  try {
    const client = await pool.connect();
    const insertQuery = `
      INSERT INTO Geofence (pet_owner_id, center_latitude, center_longitude, radius)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (pet_owner_id) DO UPDATE
      SET center_latitude = EXCLUDED.center_latitude,
          center_longitude = EXCLUDED.center_longitude,
          radius = EXCLUDED.radius
    `;
    await client.query(insertQuery, [petOwnerId, centerLatitude, centerLongitude, radius]);
    client.release();
    res.status(201).send({ message: 'Geofence set successfully' });
  } catch (error) {
    console.error('Error setting geofence:', error);
    res.status(500).send({ error: 'Internal server error' });
  }
};

module.exports = {
    setGeofence
}
