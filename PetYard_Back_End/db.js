const { Pool } = require('pg');

const pool = new Pool({
    user: "postgres",
    password: "2314",
    host: "localhost",
    port: 5432,
    database: "PetYard"
});

module.exports = pool;