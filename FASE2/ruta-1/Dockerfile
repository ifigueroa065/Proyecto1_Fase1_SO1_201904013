FROM python:3.9-slim

# Instalar dependencias
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copiar el código de la API
COPY . .

CMD ["python", "app.py"]
