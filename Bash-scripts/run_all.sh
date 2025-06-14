#!/bin/bash

set -e

echo "<<<<<<<<<<<< Compilando y cargando módulos del kernel >>>>>>>>>>>"

# Cargar el módulo del CPU
cd ../Modules/CPU
make clean && make
sudo insmod cpu_201904013.ko

# Cargar el módulo de RAM
cd ../RAM
make clean && make
sudo insmod ram_201904013.ko

echo ">>>>>>>>>>>>>>> Módulos cargados -- STEP 1/5 ✅ "
ls /proc | grep 201904013

# Desplegar y controlar contenedores de estresamiento
echo ">>>>>>>>>>>>>>> Desplegando 5 contenedores para estresar CPU y RAM -- STEP 2/5 ✅ "
for i in $(seq 1 5); do
  sudo docker run -d --name stress$i alpine:latest sh -c "
    apk update && apk add stress-ng && stress-ng --cpu 1 --vm 1 --vm-bytes 100M --timeout 60s
  "
done
echo "Contenedores desplegados:"
sudo docker ps --filter "name=stress"

echo ">>>>>>>>>>>>>>> Iniciando Recolector Go -- STEP 3/5 ✅ "
cd ../../Backend/Recolector
nohup go run main.go > recolector.log 2>&1 &
echo "********* Recolector escuchando en http://localhost:8080/metrics"

echo ">>>>>>>>>>>>>>> Iniciando API NodeJS -- STEP 4/5 ✅ "
cd ../../Backend/API
nohup node server.js > api.log 2>&1 &
echo "********* API corriendo en http://localhost:3000"

echo "Todo listo. Logs: api.log y recolector.log -- STEP 5/5 ✅"

# Bucle para reiniciar los contenedores cada 2 minutos
while true; do
  echo "Esperando 2 minutos antes de eliminar los contenedores..."
  sleep 120

  # Eliminar los contenedores actuales
  echo "Eliminando contenedores..."
  for i in $(seq 1 5); do
    sudo docker rm -f stress$i 2>/dev/null || true
  done

  # Verificar si los contenedores han sido eliminados
  echo "Verificando contenedores eliminados..."
  sudo docker ps --filter "name=stress"

  # Espera 5 segundos antes de reiniciar los contenedores
  echo "Esperando 5 segundos antes de reiniciar los contenedores..."
  sleep 5

  # Reiniciar los 5 contenedores
  echo "Reiniciando 5 contenedores para estresar CPU y RAM..."
  for i in $(seq 1 5); do
    sudo docker run -d --name stress$i alpine:latest sh -c "
      apk update && apk add stress-ng && stress-ng --cpu 1 --vm 1 --vm-bytes 100M --timeout 60s
    "
  done

  # Mostrar contenedores que están en ejecución
  echo "Contenedores activos actualmente:"
  sudo docker ps --filter "name=stress"
done
