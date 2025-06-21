#!/bin/bash

MOD_NAME="ram_201904013"
KO_FILE="${MOD_NAME}.ko"
JSON_OUT="${MOD_NAME}.json"

echo "🔧 Compilando módulo..."
make clean && make

echo "🧩 Cargando módulo..."
sudo insmod "$KO_FILE"

# Esperar un momento para que /proc se actualice
sleep 1

if [ -f "/proc/$MOD_NAME" ]; then
  echo "✅ Leyendo datos desde /proc/$MOD_NAME..."
  cat "/proc/$MOD_NAME" | tee "$JSON_OUT"
else
  echo "❌ No se encontró /proc/$MOD_NAME"
fi

echo "🧹 Descargando módulo..."
sudo rmmod "$MOD_NAME"

echo "📁 JSON guardado en: $JSON_OUT"
