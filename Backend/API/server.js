const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

app.post('/metrics', (req, res) => {
    console.log("___ Métricas recibidas:", req.body);
    res.status(200).json({ message: ' Datos recibidos correctamente ✅' });
});

app.listen(PORT, () => {
    console.log(`🚀 API escuchando en http://localhost:${PORT}`);
});
