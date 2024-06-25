const functions = require('firebase-functions');
const { Pool } = require('pg');

// Retrieve configuration
const pgConfig = {
  host: functions.config().pg.host,
  user: functions.config().pg.user,
  password: functions.config().pg.password,
  database: functions.config().pg.database,
};

const pool = new Pool(pgConfig);

// Example function to get data from PostgreSQL
exports.getData = functions.https.onRequest(async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM your_table');
    client.release();
    res.status(200).send(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send(err);
  }
});
