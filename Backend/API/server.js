const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { guardarMetricas, verTodaslasMetricas   } = require('./metrics.service'); // Función para guardar métricas

const app = express();
const PORT = process.env.PORT || 3000;

// Permitir CORS desde el frontend (ajustable para producción)
app.use(cors({
  origin: '*', // o usa 'http://frontend:4200' en entorno dockerizado
  credentials: true
}));

app.use(bodyParser.json());

// Endpoint para recibir métricas
app.post('/metrics', async (req, res) => {
  try {
    const metrics = req.body;
    await guardarMetricas (metrics); // Insertar en BD
    res.status(200).json({ message: 'Datos recibidos y almacenados correctamente ✅' });
  } catch (err) {
    console.error(' Error al procesar métricas:', err);
    res.status(500).json({ message: 'Error al procesar las métricas' });
  }
});

//* Endpoint de prueba para ver si está viva la API
app.get('/', (req, res) => {
  res.send('✅ API disponible. POST a /metrics para enviar datos.');
});

// Endpoint para obtener la última métrica
app.get('/metrics', async (req, res) => {
  try {
    const todas = await verTodaslasMetricas();
    if (todas.length === 0) return res.status(404).json({ message: 'No hay métricas aún.' });

    return res.json(todas[0]); // ← Retorna solo la más reciente
  } catch (err) {
    console.error('Error al obtener métricas:', err);
    res.status(500).json({ message: 'Error al obtener métricas' });
  }
});



// Iniciar servidor
app.listen(PORT, () => {
  console.log(`-----API escuchando en http://localhost:${PORT}`);
});
