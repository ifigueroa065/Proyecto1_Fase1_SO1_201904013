#!/bin/bash

set -e  # Detiene el script si algún comando falla

echo "/////////////////// Compilando y cargando módulos del kernel..."

# CPU Module
cd ../Modules/CPU
make clean && make
if lsmod | grep -q "cpu_201904013"; then
    echo " Módulo CPU ya cargado. Quitándolo..."
    sudo rmmod cpu_201904013
fi
sudo insmod cpu_201904013.ko
echo " Módulo CPU cargado"

# RAM Module
cd ../RAM
make clean && make
if lsmod | grep -q "ram_201904013"; then
    echo " Módulo RAM ya cargado. Quitándolo..."
    sudo rmmod ram_201904013
fi
sudo insmod ram_201904013.ko
echo " Módulo RAM cargado"

# Confirmación visual
echo " Archivos en /proc:"
ls /proc | grep 201904013
