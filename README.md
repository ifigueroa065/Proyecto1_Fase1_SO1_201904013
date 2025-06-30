
# Proyecto de Laboratorio - Sistemas Operativos 1 ⭐

**Universidad de San Carlos de Guatemala**

Facultad de Ingeniería - Escuela de Ciencias y Sistemas

Curso: **Sistemas Operativos 1** | Sección A

Catedrático: **Ing. Edgar René Ornelis Hoil**

Estudiante: **Marlon Isaí Figueroa Farfán** – *201904013*

Escuela de Vacaciones – **Junio 2025**

---

## Descripción General del Laboratorio

El laboratorio del curso **Sistemas Operativos 1** se dividió en dos fases prácticas donde se desarrollaron soluciones de monitoreo de sistemas basadas en el uso de módulos del kernel, programación concurrente, automatización de tareas y despliegue de servicios en contenedores y en la nube. El objetivo fue integrar conceptos teóricos con herramientas modernas de software libre y plataformas cloud.

---

## 🔹 Fase 1: Monitor de Servicios Linux (On-Premise)

### 🎯 Objetivo

Aplicar los conocimientos de sistemas operativos a través del desarrollo de una plataforma de monitoreo basada en módulos de kernel en C y herramientas de código abierto como Docker, Bash, Golang y NodeJS.

### ⚙️ Tecnologías Utilizadas

- Lenguaje C (Módulos del Kernel)
- Golang (Agente de monitoreo)
- Bash Scripts
- NodeJS y Angular (API y Frontend)
- Docker y Docker Compose
- Base de datos contenedorizada

### 🧩 Componentes

1.**Módulos del Kernel**: `ram_201904013`, `cpu_201904013` que exponían métricas vía `/proc`.

2.**Agente en Go**: Consulta periódicamente y expone los datos en JSON.

3.**API NodeJS**: Recibe datos del agente y los persiste.

4.**Frontend Angular**: Visualización en tiempo real.

5.**Orquestación**: Docker Compose para gestionar los servicios.

---

## 🔹 Fase 2: Monitoreo Cloud de VMs (Infraestructura en GCP)  ☁️

### 🎯 Objetivo

Expandir el proyecto hacia un entorno cloud utilizando Google Cloud Platform, Kubernetes y herramientas de escalabilidad, visualización y pruebas de carga. Se integraron nuevas APIs, un frontend más moderno y simuladores de carga para medir rendimiento.

### ⚙️ Tecnologías Utilizadas

- Kubernetes + kubectl
- Cloud SQL (MySQL)
- Cloud Run
- Docker + Docker Hub
- NodeJS + Python (APIs)
- ReactJS + WebSockets
- Locust + stress (pruebas de carga)
- Módulos del Kernel en C (RAM, CPU, Procesos)

### 🧩 Componentes

1.**Módulos del Kernel**: `cpu_201904013`, `ram_201904013`, `procesos_201904013`.

2.**Recolector en Go**: Contenedorizado y desplegado en la VM.

3.**APIs**: Python y NodeJS para escritura en Cloud SQL.

4.**WebSocket NodeJS**: Comunicación en tiempo real.

5.**Frontend en React**: Visualización de métricas y procesos.

6.**Locust**: Generación de tráfico local, distribución mediante Ingress.

7.**Kubernetes**: Orquestación, Ingress, servicios, pods, namespace `so1-fase2`.

---

## ✅ Resultados Obtenidos

- Se logró desplegar y monitorear una VM simulando escenarios de carga.
- Las métricas del sistema fueron capturadas y analizadas en tiempo real.
- Se probaron técnicas de contenedorización y despliegue escalable en la nube.
- Se integraron canales WebSocket para transmisión eficiente de datos.
- Se reforzaron habilidades en programación de bajo y alto nivel.

---

## 📌 Conclusión

El laboratorio permitió aplicar los conceptos fundamentales de los sistemas operativos modernos, combinando teoría con práctica a través de herramientas actuales como Kubernetes, Docker, Golang y programación del kernel en C. Ambas fases representan un ciclo completo de desarrollo, monitoreo, orquestación y visualización de sistemas reales.
