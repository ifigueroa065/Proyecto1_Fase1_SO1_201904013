import React, { useEffect, useState } from "react";
import io from "socket.io-client";

// Conectarse al servidor WebSocket (Backend de Node.js)
const socket = io("http://localhost:8080"); // Cambia esto si tu servidor está en otro puerto

const MetricasDashboard = () => {
  // Definimos el estado para almacenar las métricas
  const [metrics, setMetrics] = useState(null);

  useEffect(() => {
    // Escuchamos el evento 'metrics' enviado desde el backend
    socket.on("metrics", (data) => {
      setMetrics(data); // Actualizamos las métricas en el estado
    });

    // Limpiar la conexión cuando el componente se desmonte
    return () => {
      socket.off("metrics");
    };
  }, []);

  // Si las métricas no están disponibles todavía
  if (!metrics) {
    return <div>Cargando métricas...</div>;
  }

  return (
    <div>
      <h2>Métricas en Tiempo Real</h2>
      <p><strong>Uso de CPU:</strong> {metrics.cpu}%</p>
      <p><strong>Uso de RAM:</strong> {metrics.ram}%</p>

      <h3>Procesos:</h3>
      <ul>
        <li><strong>Procesos Corriendo:</strong> {metrics.procesos.procesos_corriendo}</li>
        <li><strong>Total de Procesos:</strong> {metrics.procesos.total_procesos}</li>
        <li><strong>Procesos Dormidos:</strong> {metrics.procesos.procesos_durmiendo}</li>
        <li><strong>Procesos Zombie:</strong> {metrics.procesos.procesos_zombie}</li>
        <li><strong>Procesos Parados:</strong> {metrics.procesos.procesos_parados}</li>
      </ul>

      <p><strong>Hora:</strong> {metrics.hora}</p>
    </div>
  );
};

export default MetricasDashboard;
