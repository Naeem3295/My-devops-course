const express = require('express');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'admin',
  password: process.env.DB_PASSWORD || 'password123',
  database: process.env.DB_NAME || 'mydb'
});

db.connect(err => {
  if (err) {
    console.error('❌ Database connection failed:', err.message);
  } else {
    console.log('✅ Connected to MySQL');
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'UP', timestamp: new Date() });
});

app.get('/metrics', (req, res) => {
  res.json({
    uptime: process.uptime(),
    memoryUsage: process.memoryUsage(),
    cpuUsage: process.cpuUsage()
  });
});

app.get('/api/users', (req, res) => {
  db.query('SELECT 1 as test', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ users: [], dbConnected: true });
  });
});

app.listen(port, () => {
  console.log(`🚀 Server running on port ${port}`);
});
