#!/bin/bash

# Nombre del contenedor
CONTAINER_NAME="stress_polinux"

# Duración de la carga de estrés
STRESS_DURATION=60

# Tiempo de espera después de ejecutar el contenedor (simulando recolección de métricas y construcción del JSON)
SLEEP_AFTER_RUN=30

# Tiempo de espera antes de repetir el ciclo
SLEEP_BEFORE_RESTART=15

while true; do
  echo "***** Ejecutando contenedor de estrés con polinux/stress *****"

  # Asegurarse de tener la imagen actualizada
  docker pull polinux/stress > /dev/null

  # Ejecutar el contenedor en segundo plano con carga de CPU y memoria
  docker run -d --name $CONTAINER_NAME polinux/stress \
    stress --cpu 2 --vm 1 --vm-bytes 256M --timeout ${STRESS_DURATION}s

  echo "Contenedor ejecutándose:"
  docker ps --filter "name=$CONTAINER_NAME"

  echo "Esperando $SLEEP_AFTER_RUN segundos para simular generación de JSON con métricas..."
  sleep $SLEEP_AFTER_RUN

  echo "Eliminando contenedor de estrés..."
  docker rm -f $CONTAINER_NAME 2>/dev/null || true

  echo "Esperando $SLEEP_BEFORE_RESTART segundos antes de reiniciar el ciclo..."
  sleep $SLEEP_BEFORE_RESTART
done
