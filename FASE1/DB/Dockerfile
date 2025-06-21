# Usa la imagen oficial de PostgreSQL
FROM postgres:latest

# Variables de entorno para la configuración de PostgreSQL
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=root1234
ENV POSTGRES_DB=dbmetrics

# Instalar pgAgent para evitar errores relacionados con la extensión
RUN apt-get update && apt-get install -y pgagent

# Copiar el script para crear la extensión pgAgent
COPY ./scripts/create_pgagent_extension.sh /docker-entrypoint-initdb.d/create_pgagent_extension.sh
RUN chmod +x /docker-entrypoint-initdb.d/create_pgagent_extension.sh

# Copiar el script SQL de inicialización de la tabla metrics
COPY ./scripts/init.sql /docker-entrypoint-initdb.d/init.sql

# Exponer el puerto PostgreSQL
EXPOSE 5432

# Comando por defecto para ejecutar PostgreSQL
CMD ["postgres"]
