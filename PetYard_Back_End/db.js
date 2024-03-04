const { Pool } = require('pg');

const pool = new Pool({
    user: "postgres",
    password: "yahia2002",
    host: "localhost",
    port: 5432,
    database: "PetYard"
});

module.exports = pool;