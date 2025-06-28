#!/bin/bash

set -e



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

if lsmod | grep -q "procesos_201904013"; then
  sudo rmmod procesos_201904013 && echo "✅ Módulo Procesos descargado"
else
  echo "Módulo Procesos no estaba cargado"
fi

# Limpiando compilación de los módulos
echo "Limpiando compilación de módulos..."
(cd ../Modules/CPU && make clean)
(cd ../Modules/RAM && make clean)
(cd ../Modules/PROCESOS && make clean)


# Verificar puertos ocupados (3000 para la API, 8080 para el recolector)
echo "Verificando puertos ocupados..."
ss -tuln | grep -E ':3000|:8080' && echo "⚠️  Algunos puertos siguen en uso."

# Verificar si hay procesos aún usando los puertos y matarlos
echo "Verificando procesos en puertos 3000 y 8080..."
pid_api=$(lsof -i :3000 -t)
pid_recolector=$(lsof -i :8080 -t)

if [ ! -z "$pid_api" ]; then
  echo "Matando proceso en puerto 3000 (API) con PID $pid_api..."
  kill -9 $pid_api
fi

if [ ! -z "$pid_recolector" ]; then
  echo "Matando proceso en puerto 8080 (Recolector) con PID $pid_recolector..."
  kill -9 $pid_recolector
fi

echo "✅ Entorno completamente limpio."
