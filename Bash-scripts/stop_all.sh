#!/bin/bash

echo " Deteniendo procesos en segundo plano..."

# Detener API NodeJS
pkill -f "node server.js"

# Detener Recolector en Go (si se usó go run)
pkill -f "go run main.go"

# Detener Recolector si fue compilado (ej: ./recolector)
pkill -f "./recolector"

# Si se guardó un PID del recolector
if [ -f ../Backend/Recolector/recolector.pid ]; then
  echo " Matando recolector por PID..."
  kill $(cat ../Backend/Recolector/recolector.pid) 2>/dev/null
  rm ../Backend/Recolector/recolector.pid
fi

echo "Eliminando contenedores de stress..."
for i in $(seq 1 10); do
  docker rm -f stress$i 2>/dev/null || true
done

echo " Descargando módulos del kernel..."
if lsmod | grep -q "cpu_201904013"; then
  sudo rmmod cpu_201904013 && echo " CPU descargado"
else
  echo "⚠️ Módulo CPU no estaba cargado"
fi

if lsmod | grep -q "ram_201904013"; then
  sudo rmmod ram_201904013 && echo " RAM descargado"
else
  echo "⚠️ Módulo RAM no estaba cargado"
fi

echo " Limpiando compilación de módulos..."
(cd ../Modules/CPU && make clean)
(cd ../Modules/RAM && make clean)

echo " Eliminando logs residuales..."
rm -f ../Backend/Recolector/recolector.log

echo "✅ Todo ha sido detenido y limpiado correctamente."
