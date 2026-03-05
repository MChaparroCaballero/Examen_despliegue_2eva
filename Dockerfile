# 1. Imagen base oficial de Python (versión ligera)
FROM python:3.11-slim

# 2. Configurar variables de entorno para Python
# Evita que Python genere archivos .pyc y que el log se quede en el buffer
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Establecer el directorio de trabajo
WORKDIR /app

# 4. Instalar dependencias del sistema (solo si usas librerías como psycopg2 para Postgres)
# RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# 5. Copiar primero el archivo de requerimientos
# Esto optimiza el build: si no cambias las librerías, Docker salta este paso
COPY requirements.txt .

# 6. Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# 7. Copiar el resto del código del proyecto
COPY . .

# 8. Exponer el puerto en el que corre tu API (ej. 8000)
EXPOSE 8000

# 9. Comando para arrancar la app Si usas FastAPI/Uvicorn:
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
