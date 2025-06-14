#!/bin/bash

set -e

# Detener y eliminar contenedores de stress
echo "Deteniendo y eliminando contenedores de stress..."
for i in $(seq 1 5); do
  # Detener el contenedor si está en ejecución
  sudo docker stop stress$i 2>/dev/null || true
  # Eliminar los contenedores
  sudo docker rm -f stress$i 2>/dev/null || true
done
echo "✅ Contenedores eliminados."

# Detener procesos en segundo plano (API y Recolector)
echo "Deteniendo procesos en segundo plano..."

# Detener API NodeJS (por el nombre del proceso)
pid_node=$(ps aux | grep "node server.js" | grep -v "grep" | awk '{print $2}')
if [ ! -z "$pid_node" ]; then
  echo "Matando proceso NodeJS (API) con PID $pid_node..."
  kill -9 $pid_node
else
  echo "No se encontró proceso NodeJS"
fi

# Detener Recolector Go (por el nombre del proceso)
pid_go=$(ps aux | grep "main" | grep -v "grep" | awk '{print $2}')
if [ ! -z "$pid_go" ]; then
  echo "Matando proceso Go (Recolector) con PID $pid_go..."
  kill -9 $pid_go
else
  echo "No se encontró proceso GO!"
fi

# Descargando módulos del kernel
echo "Descargando módulos del kernel..."

if lsmod | grep -q "cpu_201904013"; then
  sudo rmmod cpu_201904013 && echo "✅ Módulo CPU descargado"
else
  echo "Módulo CPU no estaba cargado"
fi

if lsmod | grep -q "ram_201904013"; then
  sudo rmmod ram_201904013 && echo "✅ Módulo RAM descargado"
else
  echo "Módulo RAM no estaba cargado"
fi

# Limpiando compilación de los módulos
echo "Limpiando compilación de módulos..."
(cd ../Modules/CPU && make clean)
(cd ../Modules/RAM && make clean)

# Eliminar logs generados
echo "Eliminando logs residuales..."
rm -f ../Backend/Recolector/recolector.log
rm -f ../Backend/API/api.log

# Verificar puertos ocupados (3000 para la API, 8080 para el recolector)
echo "Verificando puertos ocupados..."
ss -tuln | grep -E ':3000|:8080' && echo "Algunos puertos siguen en uso, asegurarse de que los servicios estén detenidos."

# Verificar si el recolector y la API están en ejecución en sus puertos
echo "Verificando procesos en puertos 3000 y 8080..."
pid_api=$(lsof -i :3000 -t)
pid_recolector=$(lsof -i :8080 -t)

if [ ! -z "$pid_api" ]; then
  echo "Proceso API aún en ejecución en el puerto 3000 con PID $pid_api"
  kill -9 $pid_api
fi

if [ ! -z "$pid_recolector" ]; then
  echo "Proceso Recolector aún en ejecución en el puerto 8080 con PID $pid_recolector"
  kill -9 $pid_recolector
fi

echo "✅ Entorno completamente limpio."
