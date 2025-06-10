#!/bin/bash

echo "🚀 Desplegando 10 contenedores ligeros para estresar CPU y RAM..."

# Verifica si la imagen ya está disponible
docker pull polinux/stress-ng:latest > /dev/null

for i in $(seq 1 10); do
  docker run -d --name stress$i --rm polinux/stress-ng \
    --cpu 1 --vm 1 --vm-bytes 100M --timeout 60s
done

echo "✅ Contenedores ejecutándose:"
docker ps --filter "name=stress"
