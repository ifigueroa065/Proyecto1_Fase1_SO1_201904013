#!/bin/bash

echo "<<<<<<<<<<<< Compilando y cargando módulos del kernel >>>>>>>>>>>"

cd ../Modules/CPU
make clean && make
sudo insmod cpu_201904013.ko

cd ../RAM
make clean && make
sudo insmod ram_201904013.ko

echo ">>>>>>>>>>>>>>> Módulos cargados -- STEP 1/5 ✅ "
ls /proc | grep 201904013

echo ">>>>>>>>>>>>>>> Desplegando 10 contenedores para estresar CPU y RAM -- STEP 2/5 ✅ "
for i in $(seq 1 10); do
  docker run -d --name stress$i --rm progrium/stress \
    --cpu 1 --vm 1 --vm-bytes 100M --timeout 60s
done
docker ps --filter "name=stress"

echo ">>>>>>>>>>>>>>> Iniciando API NodeJS -- STEP 3/5 ✅ "
cd ../../Backend/API
nohup node server.js > api.log 2>&1 &
echo "********* API corriendo en http://localhost:3000"

echo ">>>>>>>>>>>>>>> Iniciando Recolector Go -- STEP 4/5 ✅ "
cd ../Recolector
nohup go run main.go > recolector.log 2>&1 &
echo "********* Recolector escuchando en http://localhost:8080/metrics"

echo "Todo listo. Logs: api.log y recolector.log -- STEP 5/5✅"
