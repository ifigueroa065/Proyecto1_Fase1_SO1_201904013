# Etapa 1: Construcción de la app (build)
FROM node:16 AS build

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar los archivos de dependencias y luego instalar las dependencias
COPY package.json package-lock.json ./
RUN npm install

# Copiar todo el código fuente de la aplicación
COPY . .

# Construir la aplicación en modo producción
RUN npm run build

# Etapa 2: Servir la app con Nginx (producción)
FROM nginx:alpine

# Copiar los archivos construidos en la etapa anterior al contenedor de Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exponer el puerto 80 para que Nginx pueda servir la aplicación
EXPOSE 80

# Comando para ejecutar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
