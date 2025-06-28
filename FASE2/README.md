# Pasos para Crear y Activar el Entorno Virtual en Linux

A continuación, se detallan los pasos para crear y activar un entorno virtual en Linux, instalar **Locust** y ejecutar las pruebas.

## 1. Crear un entorno virtual en Linux

En la terminal, navega a la raíz de tu proyecto y ejecuta el siguiente comando para crear un entorno virtual:

```bash
python3 -m venv venv
```

Este comando creará una carpeta llamada `venv` en tu directorio de trabajo, que contendrá el entorno virtual.

## 2. Activar el entorno virtual

Ahora que el entorno virtual ha sido creado, actívalo con el siguiente comando:

```bash
source venv/bin/activate
```

Esto debería activar el entorno virtual y cambiar el prompt de la terminal para reflejar que ahora estás trabajando dentro del entorno.

## 3. Instalar Locust dentro del entorno virtual

Con el entorno virtual activado, instala **Locust** ejecutando:

```bash
pip install locust
```

## 4. Verificar que Locust esté instalado

Para confirmar que **Locust** se ha instalado correctamente, ejecuta el siguiente comando:

```bash
locust --version
```

Esto debería mostrar la versión de **Locust** instalada.

## 5. Ejecutar tu prueba de Locust

Una vez que todo esté configurado y el entorno virtual esté activo, navega a la carpeta donde se encuentra el archivo `locustfile.py` y ejecuta:

```bash
locust
```

Esto iniciará **Locust** y podrás acceder a la interfaz web en **http://localhost:8089** para configurar y ejecutar las pruebas.

Con estos pasos, podrás continuar con la prueba de carga de Locust sin problemas.
