#!/bin/bash

echo "Deteniendo procesos en segundo plano..."

# Detener API NodeJS
pid_node=$(ps aux | grep "node server.js" | grep -v "grep" | awk '{print $2}')
if [ ! -z "$pid_node" ]; then
  echo "Matando proceso NodeJS (API) con PID $pid_node..."
  kill -9 $pid_node
else
  echo "No se encontró proceso NodeJS"
fi

# Detener Recolector Go
pid_go=$(ps aux | grep "main" | grep -v "grep" | awk '{print $2}')
if [ ! -z "$pid_go" ]; then
  echo "Matando proceso Go (Recolector) con PID $pid_go..."
  kill -9 $pid_go
else
  echo "No se encontró proceso GO!"
fi

echo "Descargando módulos del kernel..."
if lsmod | grep -q "cpu_201904013"; then
  sudo rmmod cpu_201904013 && echo "CPU descargado"
else
  echo "Módulo CPU no estaba cargado"
fi

if lsmod | grep -q "ram_201904013"; then
  sudo rmmod ram_201904013 && echo "RAM descargado"
else
  echo "Módulo RAM no estaba cargado"
fi

echo "Limpiando compilación de módulos..."
(cd ../Modules/CPU && make clean)
(cd ../Modules/RAM && make clean)

echo "Eliminando logs residuales..."
rm -f ../Backend/Recolector/recolector.log
rm -f ../Backend/API/api.log

echo "Todo ha sido detenido y limpiado correctamente."
