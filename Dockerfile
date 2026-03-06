# 1. Imagen base oficial de Python (versión ligera)
FROM python:3.11-slim

# 2. Configura variables de entorno para Python
# Evita que Python genere archivos .pyc y que el log se quede en el buffer
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Establece el directorio de trabajo
WORKDIR /app


# 4. Copiar primero el archivo de requerimientos
# Esto optimiza el build: si no cambias las librerías, Docker salta este paso
COPY requirements.txt .

# 5. Luego instalamos dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copiamos el resto del código del proyecto
COPY . .

# 7. Exponemos el puerto en el que corre la API 
EXPOSE 8000

# 8. Comando para arrancar la app Si usando FastAPI/Uvicorn:
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
