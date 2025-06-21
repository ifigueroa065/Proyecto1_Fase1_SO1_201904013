# 🖥️ Monitor de Servicios Linux

**Universidad de San Carlos de Guatemala**  
Facultad de Ingeniería - Escuela de Ciencias y Sistemas  
Curso: Sistemas Operativos 1 | Sección A  
Catedrático: Ing. Edgar René Ornelis Hoil  
Marlon Isaí Figueroa Farfán - 201904013  
Escuela de Vacaciones - Junio 2025



## 📌 Descripción

Este proyecto tiene como objetivo aplicar los conocimientos adquiridos en la Unidad 1 del curso, desarrollando un **monitor de servicios Linux** basado en contenedores. Se abordan temas clave como:

- Creación de **módulos de Kernel** en C.
- Uso de **Golang** para desarrollar un agente de monitoreo concurrente.
- Implementación de **scripts Bash** para automatización.
- Orquestación con **Docker** y **Docker Compose**.
- Interfaz web para monitoreo en tiempo real usando **NodeJS** y **Angular**.

---

## 🎯 Objetivos

- Conocer el funcionamiento del **Kernel de Linux** mediante módulos escritos en C.
- Desarrollar herramientas de gestión y monitoreo usando **Golang**.
- Comprender y manejar contenedores con **Docker**.
- Automatizar procesos mediante **scripts Bash**.

---

## 🏗️ Arquitectura del Proyecto

1. **Bash Scripts**: Automatizan tareas como creación de contenedores, carga de módulos del kernel y despliegue de la plataforma.
2. **Módulos de Kernel**: Implementados en C, monitorean recursos del sistema como RAM y CPU. Exponen su información vía `/proc`.
3. **Agente de Monitoreo**: Desarrollado en Go, consulta periódicamente los módulos y expone los datos en JSON.
4. **API NodeJS**: Consume la información del agente y la guarda en la base de datos.
5. **Frontend Web**: Visualiza las métricas en tiempo real.
6. **Docker + Docker Compose**: Conteneriza todos los servicios y facilita el despliegue.
7. **Base de Datos**: Implementada como contenedor, almacena datos persistentes sobre RAM y CPU.

![arquitectura](assets/arquitecturaF1.png)

---

## ⚙️ Funcionalidades Principales

### 📦 Módulos del Kernel

- **ram_201904013**: Monitorea el uso de la memoria RAM.
- **cpu_201904013**: Monitorea el uso del CPU.
- La información es obtenida exclusivamente a través de estructuras del sistema operativo.

### 👨‍💻 Agente en Golang

- Recopila métricas del sistema.
- Implementa rutinas y canales para manejar concurrencia.
- Expone datos a través de una API local.

### 🌐 Plataforma de Monitoreo Web

- Visualización en tiempo real de uso de CPU y RAM.
- Comunicación con API y base de datos.
- Implementado con Angular

---


