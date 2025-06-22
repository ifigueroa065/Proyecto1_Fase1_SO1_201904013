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

# Cargar el módulo de Procesos
cd ../Procesos
make clean && make
sudo insmod procesos_201904013.ko

echo ">>>>>>>>>>>>>>> Módulos cargados -- STEP 1/3 ✅ "
ls /proc | grep 201904013

# Mostrar que los módulos se han cargado correctamente
echo ">>>>>>>>>>>>>>> Módulos cargados con éxito, puedes verificar en /proc."
