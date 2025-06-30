const express = require("express");
const mysql = require("mysql2");
const dotenv = require("dotenv");

dotenv.config();

const app = express();
app.use(express.json());

// Configuración de conexión a la base de datos MySQL (Cloud SQL)
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

// Ruta para recibir las métricas y almacenarlas en la base de datos
app.post("/metrics", (req, res) => {
  let data = req.body;
  console.log(`Received data: ${JSON.stringify(data)}`); // Para depuración
  // Agregar el campo "api" con valor "NodeJS"
  data.api = "NodeJS";

  // Asegurar que la fecha esté en formato MySQL (YYYY-MM-DD HH:MM:SS)
  if (data.hora) {
    data.hora = data.hora.replace("T", " ").replace("Z", "");
  }

  // Preparar la consulta para insertar las métricas
  const query = `
    INSERT INTO metrics (cpu_usage, ram_usage, processes_running, total_processes, processes_sleeping, processes_zombie, processes_stopped, timestamp, api)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const values = [
    data.cpu.porcentaje,
    data.ram.porcentaje,
    data.procesos.procesos_corriendo,
    data.procesos.total_procesos,
    data.procesos.procesos_durmiendo,
    data.procesos.procesos_zombie,
    data.procesos.procesos_parados,
    data.hora,
    data.api
  ];

  db.query(query, values, (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json({ message: "Metrics saved successfully" });
  });
});

// Iniciar el servidor
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
