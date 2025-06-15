# Usa una imagen oficial de Node.js
FROM node:16

# Establecer directorio de trabajo
WORKDIR /app

# Copiar el package.json y package-lock.json
COPY package*.json ./

# Instalar las dependencias de la API
RUN npm install

# Copiar el código de la API
COPY . .

# Exponer el puerto de la API
EXPOSE 3000

# Comando para correr la API
CMD ["node", "server.js"]
