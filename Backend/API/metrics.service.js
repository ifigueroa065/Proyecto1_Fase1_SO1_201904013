const pool = require('./db');

async function guardarMetricas(data) {
  const { cpu, ram } = data;

  const query = `
    INSERT INTO metrics (
      cpu_total, cpu_uso, cpu_libre, cpu_porcentaje,
      ram_total, ram_uso, ram_libre, ram_porcentaje
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
  `;

  const values = [
    cpu.total,
    cpu.uso,
    cpu.libre,
    cpu.porcentaje,
    ram.total,
    ram.uso,
    ram.libre,
    ram.porcentaje,
  ];

  await pool.query(query, values);
}

async function verTodaslasMetricas() {
  const query = `SELECT * FROM metrics ORDER BY fecha DESC`;
  const result = await pool.query(query);
  return result.rows;
}

module.exports = { guardarMetricas, verTodaslasMetricas };
