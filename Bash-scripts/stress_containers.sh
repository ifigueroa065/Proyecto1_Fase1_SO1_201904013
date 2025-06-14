#!/bin/bash

while true; do
  echo " ***************** Desplegando 5 contenedores ligeros con Alpine para estresar CPU y RAM *****************"

  # Verifica si la imagen de Alpine ya está disponible
  docker pull alpine:latest > /dev/null

  # Desplegar 5 contenedores con Alpine, instalando stress-ng en cada uno
  for i in $(seq 1 5); do
    docker run -d --name stress$i alpine:latest sh -c "
      apk update && apk add stress-ng && stress-ng --cpu 1 --vm 1 --vm-bytes 100M --timeout 60s
    "
  done

  echo "****************************************** Contenedores ejecutándose:"
  docker ps --filter "name=stress"

  # Espera 1 minutos (60 segundos) antes de eliminar los contenedores
  echo "Esperando 1 minuto antes de eliminar los contenedores..."
  sleep 60

  echo "Eliminando contenedores..."
  # Elimina los contenedores de stress
  for i in $(seq 1 5); do
    docker rm -f stress$i 2>/dev/null || true
  done

  echo "Esperando 10 segundos antes de reiniciar los contenedores..."
  # Espera 10 segundos antes de reiniciar los contenedores
  sleep 10
done
