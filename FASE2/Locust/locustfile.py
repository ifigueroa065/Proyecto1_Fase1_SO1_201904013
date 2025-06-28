from locust import HttpUser, task, between
import json
import os

class MetricsUser(HttpUser):
    wait_time = between(1, 2)  # Espera entre 1 y 2 segundos entre peticiones

    host = "http://localhost:8080"  # Host del recolector
    metrics_file = "metrics.json"  # Ruta del archivo JSON
    sent_metrics_file = "sent_metrics.json"  # Ruta del archivo JSON

    # Habilitar/deshabilitar tareas a través de variables
    enable_get_metrics = True  # Cambia esta variable para habilitar/deshabilitar tareas
    enable_post_metrics = False  # Cambiar a True para habilitar el POST

    def on_start(self):
        if self.enable_get_metrics:
            # Si enable_get_metrics es True, se eliminará y recargará el archivo de métricas
            if os.path.exists(self.metrics_file):
                with open(self.metrics_file, 'r') as f:
                    content = f.read().strip()
                    # Verificar si el archivo tiene datos adicionales
                    if content and not content.startswith("["):
                        content = f"[{content}]"
                    self.metrics_data = json.loads(content)
            else:
                # Si no existe, iniciar con una lista vacía
                self.metrics_data = []
        elif self.enable_post_metrics:
            # Si enable_post_metrics es True, se debe cargar las métricas desde el archivo
            if os.path.exists(self.metrics_file):
                with open(self.metrics_file, 'r') as f:
                    content = f.read().strip()
                    if content:
                        self.metrics_data = json.loads(content)  # Leer el archivo para obtener las métricas
                    else:
                        self.metrics_data = []  # Si está vacío, iniciamos una lista vacía
            else:
                self.metrics_data = []  # Si el archivo no existe, iniciamos una lista vacía

    @task(1)
    def get_metrics(self):
        if self.enable_get_metrics:
            # Realizar la petición GET al recolector
            response = self.client.get("/metrics")

            if response.status_code == 200:
                metrics = response.json()  # Convierte la respuesta a JSON
                self.metrics_data.append(metrics)  # Almacena las métricas

                # Guardar las métricas en un archivo JSON (modo sobreescribir)
                with open(self.metrics_file, 'w') as f:
                    json.dump(self.metrics_data, f, indent=2)

                # Ya no imprimimos el número de usuarios
                print(f"Usuario ha capturado las métricas.")
            else:
                print(f"Error al obtener métricas: {response.status_code}")

    @task(2)
    def post_metrics(self):
        if self.enable_post_metrics and self.metrics_data:
            # Tomar la primera métrica almacenada
            metrics = self.metrics_data.pop(0)  # Tomar la primera métrica de la lista
            ingress_url = "http://your-ingress-url/metrics"  # Actualiza esta URL si es necesario

            # Realizar la petición POST al Ingress
            response = self.client.post(ingress_url, json=metrics)

            if response.status_code == 200:
                # Guardar las métricas enviadas en un archivo JSON (modo append)
                with open(self.sent_metrics_file, 'a') as f:
                    json.dump(metrics, f, indent=2)
                    f.write("\n")

                # Ya no imprimimos el número de usuarios
                print(f"Usuario envió las métricas al Ingress.")
            else:
                print(f"Error al enviar métricas: {response.status_code}")
