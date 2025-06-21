#!/bin/bash

MOD_NAME="cpu_201904013"
KO_FILE="${MOD_NAME}.ko"
JSON_OUT="${MOD_NAME}.json"

echo "🧩 Cargando módulo..."
sudo insmod "$KO_FILE"

# Esperar a que el módulo se cree
sleep 1

if [ -f "/proc/$MOD_NAME" ]; then
  echo "✅ Leyendo JSON desde /proc/$MOD_NAME..."
  cat "/proc/$MOD_NAME" | tee "$JSON_OUT"
else
  echo "❌ No se encontró /proc/$MOD_NAME"
fi

echo "🧹 Descargando módulo..."
sudo rmmod "$MOD_NAME"

echo "📁 JSON guardado en $JSON_OUT"
