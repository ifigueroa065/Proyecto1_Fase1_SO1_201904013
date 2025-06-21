# Etapa 1: Construcción de Angular
FROM node:20 as build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar dependencias y código fuente
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa 2: Servidor Nginx
FROM nginx:stable-alpine

# Copiar la app compilada al contenedor de Nginx
COPY --from=build /app/dist/metrics /usr/share/nginx/html

# Eliminar la config por defecto de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copiar configuración personalizada (asegúrate de tener este archivo `nginx.conf`)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto por defecto
EXPOSE 80

# Iniciar Nginx en modo foreground
CMD ["nginx", "-g", "daemon off;"]
