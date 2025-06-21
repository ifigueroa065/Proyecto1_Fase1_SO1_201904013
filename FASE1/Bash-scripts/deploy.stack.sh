#!/bin/bash

echo "🐳 Desplegando aplicación completa con Docker Compose..."
cd ../docker-compose/
docker-compose up -d --build
