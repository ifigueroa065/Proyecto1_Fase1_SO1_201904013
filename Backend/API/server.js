const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

app.post('/metrics', (req, res) => {
    const { cpu, ram } = req.body;

    // Validar si los datos de CPU y RAM están presentes
    if (!cpu || !ram) {
        return res.status(400).json({ message: 'Datos inválidos, se requieren métricas de CPU y RAM' });
    }

    // Validación de los datos para asegurarse de que son numéricos
    if (typeof cpu.porcentajeUso !== 'number' || typeof ram.total !== 'number') {
        return res.status(400).json({ message: 'Formato de datos inválido en CPU o RAM' });
    }

    // Si las métricas son correctas, registrar y responder
    console.log("___ Métricas recibidas:", req.body);

    // Responder con éxito
    res.status(200).json({ message: 'Datos recibidos correctamente ✅' });
});

app.listen(PORT, () => {
    console.log(`API escuchando en http://localhost:${PORT}`);
});
