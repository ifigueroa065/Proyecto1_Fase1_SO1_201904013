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

echo ">>>>>>>>>>>>>>> Módulos cargados -- STEP 1/3 ✅ "
ls /proc | grep 201904013

# Ir a la carpeta donde está el docker-compose.yml
echo ">>>>>>>>>>>>>>> Iniciando servicios Docker con docker-compose -- STEP 2/3 ✅ "
cd ../
sudo docker compose down --remove-orphans
echo ""
echo "ℹ________ Pulsa Ctrl + C para salir..."
echo ""

# Levantar servicios en modo adjunto (no -d) para ver logs
sudo docker compose up --build
