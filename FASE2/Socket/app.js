const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const db = require("./db"); // el archivo que contiene el pool
require("dotenv").config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

setInterval(async () => {
  try {
    const [rows] = await db.query(`
      SELECT * FROM metrics ORDER BY timestamp DESC LIMIT 1
    `);

    if (rows.length > 0) {
      const row = rows[0];

      const metrics = {
        cpu: {
          uso: row.cpu_usage,
          porcentaje: row.cpu_usage
        },
        ram: {
          uso: row.ram_usage,
          porcentaje: row.ram_usage
        },
        procesos: {
          procesos_corriendo: row.processes_running,
          total_procesos: row.total_processes,
          procesos_durmiendo: row.processes_sleeping,
          procesos_zombie: row.processes_zombie,
          procesos_parados: row.processes_stopped
        },
        hora: row.timestamp.toISOString()
      };

      io.emit("metrics", metrics);
    }
  } catch (err) {
    console.error("Error al obtener métricas:", err.message);
  }
}, 5000);

app.get("/", (req, res) => {
  res.send("Servidor WebSocket en funcionamiento. Conecte el frontend.");
});

const port = 8080;
server.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});
