#!/bin/bash

set -e

echo "<<<<<<<<<<<< Compilando y cargando módulos del kernel >>>>>>>>>>>"

# Cargar el módulo del CPU
cd ../Modules/CPU
echo "Compilando y cargando el módulo CPU..."
make clean && make
sudo insmod cpu_201904013.ko
if lsmod | grep -q "cpu_201904013"; then
  echo "Módulo CPU cargado correctamente ✅"
else
  echo "Error al cargar el módulo CPU "
  exit 1
fi

# Cargar el módulo de RAM
cd ../RAM
echo "Compilando y cargando el módulo RAM..."
make clean && make
sudo insmod ram_201904013.ko
if lsmod | grep -q "ram_201904013"; then
  echo "Módulo RAM cargado correctamente ✅"
else
  echo "Error al cargar el módulo RAM"
  exit 1
fi

# Cargar el módulo de Procesos
cd ../PROCESOS
echo "Compilando y cargando el módulo de Procesos..."
make clean && make
sudo insmod procesos_201904013.ko
if lsmod | grep -q "procesos_201904013"; then
  echo "Módulo Procesos cargado correctamente ✅"
else
  echo "Error al cargar el módulo de Procesos"
  exit 1
fi

echo ">>>>>>>>>>>>>>> Módulos cargados con éxito -- STEP 1/3 ✅ "

# Verificar si los módulos están en /proc
echo "Verificando que los módulos estén en /proc..."
if ls /proc | grep -q "cpu_201904013"; then
  echo "Módulo CPU encontrado en /proc ✅"
else
  echo "No se encontró el módulo CPU en /proc"
fi

if ls /proc | grep -q "ram_201904013"; then
  echo "Módulo RAM encontrado en /proc"
else
  echo "No se encontró el módulo RAM en /proc"
fi

if ls /proc | grep -q "procesos_201904013"; then
  echo "Módulo Procesos encontrado en /proc"
else
  echo "No se encontró el módulo Procesos en /proc"
fi

echo ">>>>>>>>>>>>>>> Módulos cargados con éxito, puedes verificar en /proc."

