# Imagen base
FROM node:18

# Crear directorio de la app
WORKDIR /usr/src/app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del código
COPY . .

# Exponer el puerto que usará la app
EXPOSE 8080

# Comando para ejecutar tu servidor (ajustado a app.js)
CMD ["node", "app.js"]
