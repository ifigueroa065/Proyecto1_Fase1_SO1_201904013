require('dotenv').config(); // <-- Carga las variables desde .env

const { Pool } = require('pg');

const pool = new Pool({
  user: process.env.DB_USER || 'admin',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'dbmetrics',
  password: process.env.DB_PASSWORD || 'root1234',
  port: process.env.DB_PORT || 5432,
});

module.exports = pool;
