from flask import Flask, request, jsonify
import mysql.connector
import os
from datetime import datetime  # ← Importación necesaria

app = Flask(__name__)

# Configuración de conexión a la base de datos Cloud SQL (MySQL)
db_config = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', 'admin123'),
    'database': os.getenv('DB_NAME', 'metrics_db')
}

# Ruta para recibir las métricas y almacenarlas en la base de datos
@app.route('/metrics', methods=['POST'])
def save_metrics():
    data = request.get_json()

    # Agregar el campo "api" al JSON con valor "Python"
    data['api'] = 'Python'

    try:
        # Convertir hora a formato compatible con MySQL
        if 'hora' in data:
            data['hora'] = datetime.fromisoformat(data['hora'].replace("Z", "")).strftime('%Y-%m-%d %H:%M:%S')

        # Conectar a la base de datos MySQL
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        # Preparar la consulta para insertar las métricas
        query = """
        INSERT INTO metrics (cpu_usage, ram_usage, processes_running, total_processes,
                             processes_sleeping, processes_zombie, processes_stopped, timestamp, api)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        values = (
            data['cpu']['porcentaje'],
            data['ram']['porcentaje'],
            data['procesos']['procesos_corriendo'],
            data['procesos']['total_procesos'],
            data['procesos']['procesos_durmiendo'],
            data['procesos']['procesos_zombie'],
            data['procesos']['procesos_parados'],
            data['hora'],
            data['api']
        )

        cursor.execute(query, values)
        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"message": "Metrics saved successfully"}), 200

    except mysql.connector.Error as err:
        return jsonify({"error": f"Error: {err}"}), 500
    except Exception as e:
        return jsonify({"error": f"Unexpected error: {e}"}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5050)
