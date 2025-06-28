from locust import HttpUser, task, between
import json

class MetricsUser(HttpUser):
    wait_time = between(1, 2)  # Espera entre 1 y 2 segundos entre peticiones

    @task
    def get_metrics(self):
        response = self.client.get("/metrics")  # Realiza la petición GET al recolector

        if response.status_code == 200:
            metrics = response.json()  # Convierte la respuesta a JSON
            print("Métricas obtenidas:", json.dumps(metrics, indent=2))
        else:
            print(f"Error al obtener métricas: {response.status_code}")
