# Usa una imagen oficial de Golang
FROM golang:1.22-alpine

# Establecer directorio de trabajo
WORKDIR /app

# Copiar el código fuente del recolector
COPY . .

# Instalar dependencias (si las tienes en el proyecto)
RUN go mod tidy

# Exponer el puerto para el recolector
EXPOSE 8080

# Comando para correr el recolector
CMD ["go", "run", "main.go"]
