from flask import Flask, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

# Configuración de conexión a la base de datos Cloud SQL (MySQL)
db_config = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', 'yourpassword'),
    'database': os.getenv('DB_NAME', 'metrics_db')
}

# Ruta para recibir las métricas y almacenarlas en la base de datos
@app.route('/metrics', methods=['POST'])
def save_metrics():
    data = request.get_json()

    # Conectar a la base de datos MySQL
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        # Preparar la consulta para insertar las métricas
        query = """
        INSERT INTO metrics (cpu_usage, ram_usage, processes_running, total_processes, processes_sleeping, processes_zombie, processes_stopped, timestamp)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        
        values = (
            data['cpu']['porcentaje'],
            data['ram']['porcentaje'],
            data['procesos']['procesos_corriendo'],
            data['procesos']['total_procesos'],
            data['procesos']['procesos_durmiendo'],
            data['procesos']['procesos_zombie'],
            data['procesos']['procesos_parados'],
            data['hora']
        )

        cursor.execute(query, values)
        conn.commit()

        cursor.close()
        conn.close()

        return jsonify({"message": "Metrics saved successfully"}), 200

    except mysql.connector.Error as err:
        return jsonify({"error": f"Error: {err}"}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
