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


crear el cluster

```bash
gcloud container clusters create so1-fase2 --num-nodes=3 --tags=allin,allout --machine-type=n1-standard-2 --zone us-central1-f
```
listar nodos para saber si funcionó

```bash
kubectl get nodes
```

crear  el namespace:

```bash
kubectl create namespace so1-fase2-fase2
```
setearle un con texto

```bash
kubectl config set-context --current --namespace=so1-fase2-fase2
```
darle permisos de admin
```bash
kubectl create clusterrolebinding admin-so1-fase2-fase2 --clusterrole=cluster-admin --serviceaccount=so1-fase2-fase2:default
```

```bash
kubectl auth can-i list services --namespace=so1-fase2-fase2 --as=system:serviceaccount:so1-fase2-fase2:default
```
agregar los secret al cluster

```bash
kubectl apply -f python-api-secret.yaml
kubectl apply -f node-api-secret.yaml
```

eliminar yaml por si la carlitos xd

```bash
kubectl delete -f file.yaml
```

reiniciar yaml por si hay actualizacion

```bash
kubectl rollout restart deployment node-api -n so1-fase2
```

consultar las ips donde se exponen las apis:

```bash
kubectl get services
kubectl get ingress
```

Configuración de GCP Cli en Windows:

https://youtu.be/rpmOM5jJJfY?si=3YYzFDSwXd8rPdth

Configuración de GCP Cli en ubuntu:

https://youtu.be/zERGwIeAhfc?si=aRrptzORO6CwW8pm

