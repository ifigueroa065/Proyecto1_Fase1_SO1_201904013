#!/bin/bash

set -e

echo "🧼 Eliminando contenedores de stress..."
for i in $(seq 1 10); do
  docker rm -f stress$i 2>/dev/null || true
done
echo "✅ Contenedores eliminados."

echo "❌ Descargando módulos del kernel..."

if lsmod | grep -q "cpu_201904013"; then
  sudo rmmod cpu_201904013 && echo "✅ Módulo CPU descargado"
else
  echo "⚠️  Módulo CPU no estaba cargado"
fi

if lsmod | grep -q "ram_201904013"; then
  sudo rmmod ram_201904013 && echo "✅ Módulo RAM descargado"
else
  echo "⚠️  Módulo RAM no estaba cargado"
fi

echo "🧹 Limpiando compilación..."
(cd ../Modules/CPU && make clean)
(cd ../Modules/RAM && make clean)

echo "✅ Entorno completamente limpio."
