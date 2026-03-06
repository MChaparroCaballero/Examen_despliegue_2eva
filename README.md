# 📚 FerreApp API REST - Guía Educativa
## API de Gestión de Productos de Ferretería con dockerizacion
## Por María Chaparro Caballero
[Enlace de perfil de github:](https://github.com/MChaparroCaballero)

---

## 🚀 Quick Start

### 📋 Descripción del Proyecto

**FerreApp** es una API REST desarrollada con **FastAPI** para gestionar un catálogo de productos de ferretería. El proyecto implementa una arquitectura de microservicios usando **Docker** y **Docker Compose**, con contenedores independientes para la aplicación y la base de datos MariaDB.

**Tecnologías:** FastAPI, Python 3.11, MariaDB 10.11, Docker, Pydantic

### ⚡ Cómo Ejecutar el Sistema

#### **Requisitos:**
- Docker Desktop instalado y en ejecución

#### **Comando para levantar los contenedores:**

```bash
docker-compose up --build
```

#### **Acceso a la aplicación:**
- **API REST:** http://localhost:8000
- **Documentación Interactiva (Swagger):** http://localhost:8000/docs

**¡Listo!** El sistema estará funcionando en menos de 60 segundos.

---

## � Cómo se Dockerizó el Proyecto

### 📝 Archivos Necesarios para Dockerizar

Para dockerizar FerreApp, se crearon **2 archivos clave**:

#### **1. Dockerfile** - Construye la imagen de la aplicación

```dockerfile
# Imagen base de Python 3.11 (ligera)
FROM python:3.11-slim

# Establecer directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar archivo de dependencias
COPY requirements.txt .

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el código de la aplicación al contenedor
COPY . .

# Exponer el puerto 8000 para acceso externo
EXPOSE 8000

# Comando para ejecutar la aplicación con Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**¿Qué hace cada línea?**
- `FROM python:3.11-slim`: Usa una imagen base de Python optimizada
- `WORKDIR /app`: Crea y se posiciona en el directorio `/app` dentro del contenedor
- `COPY requirements.txt .`: Copia las dependencias al contenedor
- `RUN pip install...`: Instala todas las librerías Python necesarias
- `COPY . .`: Copia todo el código fuente al contenedor
- `EXPOSE 8000`: Declara que el contenedor escucha en el puerto 8000
- `CMD [...]`: Define el comando que ejecuta la API con Uvicorn

#### **2. docker-compose.yml** - Orquesta múltiples contenedores

```yaml
version: '3.8'

services:
  # Servicio de Base de Datos
  db:
    image: mariadb:10.11
    container_name: ferreapp_db
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: FerreApp
      MYSQL_USER: ferreapp
      MYSQL_PASSWORD: ferreapp123
    volumes:
      - db_data:/var/lib/mysql
      - ./docs/init_db.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "3306:3306"
    networks:
      - ferreapp_network

  # Servicio de la API
  api:
    build: .
    container_name: ferreapp_api
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_USER: ferreapp
      DB_PASSWORD: ferreapp123
      DB_NAME: FerreApp
      DB_PORT: 3306
    ports:
      - "8000:8000"
    networks:
      - ferreapp_network

volumes:
  db_data:

networks:
  ferreapp_network:
    driver: bridge
```

**¿Qué hace cada sección?**

- **`services.db`**: Contenedor de MariaDB
  - Usa imagen oficial `mariadb:10.11`
  - Define variables de entorno para crear BD y usuario
  - `volumes`: Persiste datos en `db_data` y ejecuta `init_db.sql` al iniciar
  - Publica puerto 3306 para acceso desde el host

- **`services.api`**: Contenedor de FastAPI
  - `build: .` → Construye imagen usando el Dockerfile del proyecto
  - `depends_on: db` → Espera a que la BD esté lista antes de iniciar
  - Variables de entorno apuntan al servicio `db` (no a localhost)
  - Publica puerto 8000 para acceder a la API

- **`volumes`**: Define almacenamiento persistente para la BD

- **`networks`**: Crea red privada `ferreapp_network` donde los contenedores se comunican

### 🔄 Proceso de Dockerización Paso a Paso

**Paso 1: Crear el Dockerfile**
```bash
# Definir imagen base, copiar código, instalar dependencias
```

**Paso 2: Crear docker-compose.yml**
```bash
# Definir servicios (api + db), red, volúmenes
```

**Paso 3: Configurar variables de entorno**
```bash
# La API lee DB_HOST=db (nombre del servicio, no localhost)
```

**Paso 4: Construir y levantar contenedores**
```bash
docker-compose up --build
```

**¿Qué sucede al ejecutar `docker-compose up --build`?**

1. 🏗️ **Docker Compose lee** el archivo `docker-compose.yml`
2. 📦 **Construye la imagen** de la API usando el `Dockerfile`
3. 🗄️ **Descarga la imagen** de MariaDB 10.11 desde Docker Hub
4. 🌐 **Crea la red** `ferreapp_network`
5. 💾 **Crea el volumen** `db_data` para persistencia
6. 🚀 **Inicia el contenedor `db`** (MariaDB)
   - Ejecuta `init_db.sql` para crear tablas
7. 🚀 **Inicia el contenedor `api`** (FastAPI)
   - Se conecta a `db` mediante la red Docker
8. ✅ **Aplicación lista** en http://localhost:8000

### 🎯 Ventajas de Esta Dockerización

- ✅ **Portabilidad**: Funciona igual en Windows, Mac y Linux
- ✅ **Aislamiento**: No contamina el sistema host
- ✅ **Reproducibilidad**: Mismo entorno en desarrollo y producción
- ✅ **Escalabilidad**: Fácil agregar más instancias
- ✅ **Limpieza**: `docker-compose down` elimina todo

---

## �📖 Índice
1. [Caso de Uso: Historia de Ferremax](#caso-de-uso-historia-de-ferremax)
2. [El Problema a Resolver](#el-problema-a-resolver)
3. [Especificación de Requisitos](#especificación-de-requisitos)
4. [Descripción General](#descripción-general)
5. [Conceptos de Arquitectura de Software](#conceptos-de-arquitectura-de-software)
6. [Librerías Python y su Función](#librerías-python-y-su-función)
7. [Estructura del Proyecto](#estructura-del-proyecto)
8. [🐳 Docker y Containerización](#-docker-y-containerización)
9. [Instalación y Ejecución](#instalación-y-ejecución)
10. [Endpoints de la API](#endpoints-de-la-api)
11. [Validaciones Implementadas](#validaciones-implementadas)
12. [Patrones de Diseño Utilizados](#patrones-de-diseño-utilizados)

---
## 📘 Introducción

### 1. Contexto de la actividad

En el entorno profesional actual, el despliegue de aplicaciones mediante contenedores se ha convertido en una práctica estándar en la industria del software. Tecnologías como Docker permiten empaquetar aplicaciones junto con sus dependencias, facilitando su distribución, escalabilidad y mantenimiento.

En este examen se evaluará la capacidad del estudiante para desplegar una aplicación web utilizando contenedores Docker, configurando correctamente su arquitectura y asegurando la comunicación entre los distintos servicios.

El objetivo es comprobar que el alumno comprende los principios básicos de contenedorización, orquestación simple con Docker Compose y conexión entre servicios dentro de una red Docker.

### 🎯 Objetivo del examen

El alumno deberá desplegar una aplicación web funcional utilizando Docker, siguiendo una arquitectura basada en múltiples contenedores.

La aplicación puede ser desarrollada en cualquier lenguaje o framework web (por ejemplo: Node.js, Python, PHP, Java, etc.), siempre que cumpla con los requisitos técnicos definidos.

### 🏗 Arquitectura obligatoria

La solución deberá implementar una arquitectura mínima compuesta por tres elementos principales:

**1️⃣ Contenedor de la aplicación web**

- Debe contener el código de la aplicación.
- Debe construirse mediante un Dockerfile.
- Debe poder iniciarse correctamente dentro de un contenedor.

**2️⃣ Contenedor de base de datos**

- Debe utilizar MySQL como motor de base de datos.
- Debe ejecutarse como un contenedor independiente.
- La aplicación debe poder conectarse correctamente a esta base de datos.

**3️⃣ Red Docker**

- Debe existir una red Docker que permita la comunicación entre los contenedores.
- La aplicación debe conectarse al contenedor de la base de datos mediante esta red.

### 📦 Requisitos técnicos obligatorios

El proyecto deberá incluir obligatoriamente:

**1️⃣ Dockerfile**

Debe existir un archivo Dockerfile que permita construir la imagen de la aplicación.

El Dockerfile debe:

- Definir una imagen base adecuada.
- Copiar el código de la aplicación al contenedor.
- Instalar las dependencias necesarias.
- Definir el comando de ejecución de la aplicación.
- Exponer el puerto necesario para acceder al servicio.

**2️⃣ Docker Compose**

El proyecto debe incluir un archivo `docker-compose.yml`

Este archivo debe definir al menos los siguientes servicios:

- `app` → contenedor de la aplicación
- `db` → contenedor de MySQL

Además, debe incluir:

- Configuración de red
- Variables de entorno necesarias
- Persistencia de datos (si aplica)
- Puertos publicados para acceso desde el host

**3️⃣ Conexión a base de datos**

La aplicación debe:

- Conectarse correctamente al contenedor de MySQL.
- Realizar al menos una operación sobre la base de datos, por ejemplo:
  - insertar datos
  - consultar datos
  - listar registros

No se evaluará la complejidad del sistema, sino la correcta integración entre aplicación y base de datos dentro del entorno Docker.

### ⚙️ Requisitos funcionales

La aplicación deberá cumplir lo siguiente:

- Debe ejecutarse correctamente dentro del contenedor.
- Debe ser accesible desde el navegador o desde un cliente HTTP.
- Debe demostrar conexión funcional con la base de datos.
- Debe ejecutarse correctamente mediante: `docker compose up`

Al momento de la evaluación, el profesor deberá poder verificar que:

- Los contenedores se crean correctamente
- Los servicios están en ejecución
- La aplicación responde correctamente

### 📁 Entrega del proyecto

El proyecto debe entregarse con la siguiente estructura mínima:

```
proyecto-docker/
│
├── docker-compose.yml
├── Dockerfile
├── app/
│   └── código de la aplicación
│
└── README.md
```

El archivo README.md debe incluir:

- descripción breve del proyecto
- instrucciones para ejecutar el sistema
- comando para levantar los contenedores

### 🚫 Restricciones

No se permite:

- ejecutar la base de datos fuera de Docker
- ejecutar la aplicación directamente en el host
- utilizar bases de datos externas

**Todos los servicios deben ejecutarse dentro de contenedores Docker.**

---

## 🏢 Caso de Uso: Historia de Ferremax

### El Contexto Histórico

**Ferremax** es una ferretería familiar ubicada en el corazón de la ciudad, con más de 30 años de trayectoria. Comenzó vendiendo herramientas básicas en un pequeño local y, gracias a su excelente servicio, ha crecido hasta tener 3 sucursales y un catálogo de más de **1,000 productos diferentes**.

El dueño, Don Carlos, ha visto evolucionar el comercio desde los cuadernos manuales hasta las primeras computadoras en los años 90. Sin embargo, hasta hace poco seguía usando:
- **Fichas en cartón** para registrar cada producto (nombre, código, precio)
- **Cuadernos de inventario** anotados a mano
- **Llamadas telefónicas** para consultar disponibilidad
- **Facturas manuscritas** que se perdían constantemente
- **Cálculos manuales** que cometían errores constantemente

### El Punto de Inflexión

El año 2024, durante una sesión de capacitación en tecnología para pymes, Don Carlos descubrió que una **API REST usando Docker** podría revolucionar su negocio. Vio cómo otras ferrerías usaban sistemas digitales modernos y contenedores que garantizaban el mismo funcionamiento en cualquier computadora, y se dio cuenta de que:

1. **Pérdida de información:** No sabía con exactitud cuántas herramientas tenía en inventario
2. **Ineficiencia:** Los clientes llamaban para preguntar disponibilidad y nadie podía responder rápido
3. **Errores en precios:** Los vendedores a veces cobraban precios incorrectos
4. **Falta de trazabilidad:** No sabía qué productos se vendían más
5. **Clientes frustrados:** Viajaban al local sin saber si había el producto que buscaban

### La Decisión

Don Carlos decidió **invertir en un sistema digital** para:
- ✅ Registrar productos de forma ordenada y consistente
- ✅ Consultar inventario en tiempo real
- ✅ Permitir actualizaciones rápidas de precios y stock
- ✅ Eliminar productos discontinuados
- ✅ Generar reportes confiables
- ✅ Ofrecer a clientes una **API pública** para consultar catálogo

---

## 🎯 El Problema a Resolver

Don Carlos contrata a un equipo de **desarrolladores junior** (ustedes) para construir la solución. El objetivo es crear una **API REST moderna, escalable y segura** que permita gestionar el catálogo de productos de Ferremax.

### Requisitos del Negocio

#### 1. **Datos de Productos a Gestionar**

Cada producto en Ferremax tiene la siguiente información:

```
┌─────────────────────────────────────────────────────┐
│                   PRODUCTO                          │
├─────────────────────────────────────────────────────┤
│ • ID único (número secuencial)                      │
│ • Nombre (ej: "Martillo 16oz")                      │
│ • Descripción (detalles del producto)               │
│ • Precio (en dólares, con centavos)                 │
│ • Stock disponible (cantidad en almacén)            │
│ • Categoría (Herramientas, Tornillería, etc.)       │
│ • Código SKU (código único de inventario)           │
│ • Estado (activo o inactivo)                        │
│ • Fecha de creación (cuándo se registró)            │
└─────────────────────────────────────────────────────┘
```

#### 2. **Operaciones Necesarias (CRUD)**

La API debe permitir:

┌─────────────────────────────────────────────────────────────────────┐
| Operación | Descripción | Endpoint (sugerido)                       |
|-----------|-------------|---------------------                      |
| **Create** | Agregar nuevo producto | `POST /productos`             |
| **Read** | Listar todos los productos | `GET /productos`            |
| **Read** | Obtener un producto por ID | `GET /productos/{id}`       |
| **Update** | Actualizar producto existente | `PUT /productos/{id}`  |
| **Delete** | Eliminar un producto | `DELETE /productos/{id}`        |
└─────────────────────────────────────────────────────────────────────┘
#### 3. **Ejemplos de Productos Reales**

La Ferretería Ferremax tiene estos productos en su catálogo inicial:

```json
{
  "nombre": "Martillo 16oz",
  "descripcion": "Martillo de acero con mango ergonómico",
  "precio": 12.50,
  "stock": 25,
  "categoria": "Herramientas",
  "codigo_sku": "MART-16OZ",
  "activo": true
}
```

```json
{
  "nombre": "Taladro eléctrico",
  "descripcion": "Taladro eléctrico 500W",
  "precio": 65.99,
  "stock": 10,
  "categoria": "Herramientas eléctricas",
  "codigo_sku": "TAL-500W",
  "activo": true
}
```

```json
{
  "nombre": "Destornillador plano",
  "descripcion": "Destornillador plano 5mm",
  "precio": 4.20,
  "stock": 40,
  "categoria": "Herramientas",
  "codigo_sku": "DEST-PL-5",
  "activo": true
}
```

---

## 📋 Especificación de Requisitos

### Requisitos de Datos (Tabla: `producto`)

```sql
CREATE TABLE producto (
  id_producto INT UNSIGNED AUTO_INCREMENT,           -- ID único, autoincremental
  nombre VARCHAR(80) NOT NULL,                        -- Nombre obligatorio, máx 80 caracteres
  descripcion VARCHAR(255) NULL,                      -- Descripción opcional, máx 255 caracteres
  precio DECIMAL(10,2) NOT NULL,                      -- Precio obligatorio: 8 dígitos + 2 decimales
  stock INT NOT NULL,                                 -- Stock obligatorio, número entero
  categoria VARCHAR(50) NOT NULL,                     -- Categoría obligatoria, máx 50 caracteres
  codigo_sku VARCHAR(20) NOT NULL,                    -- Código SKU único, máx 20 caracteres
  activo BOOLEAN NOT NULL DEFAULT TRUE,               -- Estado: activo por defecto
  
  CONSTRAINT pk_producto PRIMARY KEY (id_producto),
  CONSTRAINT uq_producto_sku UNIQUE (codigo_sku)      -- El SKU debe ser único
);
```

### Requisitos de Validación (Reglas de Negocio)

Estos datos **DEBEN ser validados** cuando se creen o actualicen productos:

| Campo | Validación | Ejemplo válido | Ejemplo inválido |
|-------|-----------|-----------------|-----------------|
| **nombre** | No vacío, máx 80 caracteres | "Martillo 16oz" | "" o cadena > 80 chars |
| **descripcion** | Opcional, máx 255 caracteres | "Martillo de acero" | cadena > 255 chars |
| **precio** | Positivo, máx 999,999.99 | 12.50 | -5.00, 1000000.00 |
| **stock** | No negativo, entero | 25, 0 | -5, 3.5 |
| **categoria** | No vacío, máx 50 caracteres | "Herramientas" | "" o > 50 chars |
| **codigo_sku** | No vacío, único, máx 20 caracteres | "MART-16OZ" | "" o duplicado |
| **activo** | Booleano | true, false | "si", 1 |

### Requisitos Funcionales de la API

1. ✅ **Crear producto**: Validar datos antes de insertar
2. ✅ **Leer todos**: Retornar lista de productos con formato JSON
3. ✅ **Leer por ID**: Retornar producto específico o error 404
4. ✅ **Actualizar**: Modificar producto existente con validaciones
5. ✅ **Eliminar**: Borrar producto de la base de datos
6. ✅ **Manejo de errores**: Respuestas HTTP adecuadas (200, 201, 400, 404, 500)

### Requisitos Técnicos

- **Tecnología:** FastAPI (Python 3.10+)
- **Base de datos:** MySQL / MariaDB
- **Validación:** Pydantic v2
- **Servidor:** Uvicorn (ASGI)
- **Patrón:** Arquitectura en capas (API → Lógica → Datos → BD)

---

## 🎯 Descripción General

**FerreApp** es una API REST que permite gestionar un catálogo de productos de ferretería con operaciones CRUD (Create, Read, Update, Delete) completas. Es un proyecto **educativo** que implementa buenas prácticas de desarrollo de software y patrones de diseño modernos y profesionales.

**Dominio de negocio:** Gestión de inventario de herramientas y materiales de ferretería.

**Tecnologías principales:**
- **Backend:** FastAPI (Python moderno y de alto rendimiento)
- **Base de datos:** MariaDB/MySQL (relacional)
- **Servidor ASGI:** Uvicorn (servidor asincrónico)
- **Validación:** Pydantic (validación declarativa)

### ☁️ Enfoque de Despliegue: Cloud Native

A diferencia de una aplicación tradicional, **FerreApp está diseñada bajo el paradigma de "Cloud Native"**, lo que significa que su entorno natural es un contenedor. El objetivo central de este proyecto es demostrar la **orquestación de servicios (API + BD) mediante Docker**, garantizando que la aplicación funcione de forma **idéntica en el ordenador de Don Carlos, en el tuyo o en la nube**.

Este enfoque moderno proporciona:
- ✅ **Portabilidad:** Mismo comportamiento en desarrollo, testing y producción
- ✅ **Escalabilidad:** Agregar más instancias es trivial
- ✅ **Mantenibilidad:** Dependencias aisladas no afectan al host
- ✅ **DevOps-ready:** Preparado para CI/CD y orquestadores como Kubernetes

---

## 🏗️ Conceptos de Arquitectura de Software

### 1. **Arquitectura en Capas (Layered Architecture)**

FerreApp implementa una arquitectura en **4 capas** que separa responsabilidades:

```
┌─────────────────────────────────────────────────────┐
│  Capa de Presentación (API REST)                    │
│  Archivos: app/main.py                              │
│  - Define endpoints (@app.get, @app.post, etc.)     │
│  - Maneja requests/responses HTTP                   │
│  - Inyecta dependencias                             │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│  Capa de Lógica de Negocio (Modelos)                │
│  Archivos: app/main.py (Pydantic models)            │
│  - ProductoBase: validaciones comunes               │
│  - ProductoCreate/Update: para operaciones CRUD     │
│  - Producto: modelo completo con ID                 │
│  - Validación automática con @field_validator       │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│  Capa de Acceso a Datos (Data Access Layer)         │
│  Archivos: app/database.py                          │
│  - fetch_all_productos()                            │
│  - fetch_producto_by_id(id)                         │
│  - insert_producto(...)                             │
│  - update_producto(...)                             │
│  - delete_producto(id)                              │
│  - map_rows_to_productos() ← función helper         │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│  Capa de Persistencia (Base de Datos)               │
│  Archivos: docs/init_db.sql                         │
│  - Tabla: producto                                  │
│  - Campos: id_producto, nombre, precio, stock...    │
│  - Motor: MariaDB / MySQL                           │
└─────────────────────────────────────────────────────┘
```

**¿Por qué separar en capas?**

✅ **Separation of Concerns (SoC):** Cada capa tiene una responsabilidad única
✅ **Mantenibilidad:** Cambios en BD no afectan la API
✅ **Testabilidad:** Cada capa se puede testear independientemente
✅ **Reutilización:** Lógica centralizada
✅ **Escalabilidad:** Fácil agregar nuevas funcionalidades

### 2. **Patrón Repository**

El archivo `database.py` implementa el **patrón Repository**, encapsulando toda la lógica de acceso a datos:

```python
# Funciones que abstraen las operaciones de BD
fetch_all_productos()           # SELECT * FROM producto
fetch_producto_by_id(id)        # SELECT * FROM producto WHERE id = ?
insert_producto(...)            # INSERT INTO producto VALUES (...)
update_producto(id, ...)        # UPDATE producto SET ... WHERE id = ?
delete_producto(id)             # DELETE FROM producto WHERE id = ?
```

**Beneficios del patrón Repository:**

✅ **Abstracción:** Los endpoints no saben cómo funciona la BD
✅ **Reemplazabilidad:** Cambiar MySQL por PostgreSQL sin tocar endpoints
✅ **Testabilidad:** Mockear fácilmente en tests unitarios
✅ **Centralización:** Un solo lugar donde editar queries

### 3. **Model Segregation (Segregación de Modelos)**

FerreApp NO usa un único modelo `Producto` para todo. Usa 5 modelos especializados:

```python
# 1️⃣ ProductoBase
class ProductoBase(BaseModel):
    nombre: str
    descripcion: Optional[str]
    precio: float
    # ... validaciones comunes
    
    @field_validator('nombre')
    def validar_nombre(cls, v): ...

# 2️⃣ ProductoDB
# Para lectura desde BD (sin validaciones estrictas)
class ProductoDB(BaseModel):
    id_producto: int
    nombre: str
    # ... sin validadores

# 3️⃣ ProductoCreate (hereda de ProductoBase)
# Para crear nuevos (sin ID)
class ProductoCreate(ProductoBase):
    pass

# 4️⃣ ProductoUpdate (hereda de ProductoBase)
# Para actualizar (sin ID)
class ProductoUpdate(ProductoBase):
    pass

# 5️⃣ Producto (hereda de ProductoBase)
# Modelo completo con ID
class Producto(ProductoBase):
    id_producto: int
```

**Principio:** Interface Segregation Principle (ISP) - Usar interfaces específicas, no genéricas.

### 4. **Validación de Datos con Pydantic**

Pydantic proporciona 2 niveles de validación:

**Nivel 1: Validaciones Declarativas con `Field()`**
```python
nombre: Annotated[str, Field(min_length=1, max_length=80)]
precio: float = Field(ge=0)
stock: int = Field(ge=0)
```

**Nivel 2: Validaciones Personalizadas con `@field_validator`**
```python
@field_validator('nombre')
def validar_nombre(cls, v: str) -> str:
    if not v or not v.strip():
        raise ValueError('No puede estar vacío')
    return v.strip()
```

### 5. **RESTful API Design**

| Método | Endpoint | Status | Idempotente |
|--------|----------|--------|-------------|
| GET | `/productos` | 200 | ✓ |
| GET | `/productos/{id}` | 200 | ✓ |
| POST | `/productos` | **201** | ✗ |
| PUT | `/productos/{id}` | 200 | ✓ |
| DELETE | `/productos/{id}` | 200 | ✓ |

---

## 📦 Librerías Python y su Función

### **Librerías Core**

#### 1. **FastAPI**
Framework moderno para crear APIs REST. Define endpoints, maneja validación y genera documentación automática.

#### 2. **Pydantic**
Validación de datos y serialización. Proporciona type hints + validación automática.

#### 3. **Uvicorn**
Servidor ASGI ultrarrápido. Ejecuta la aplicación FastAPI.

#### 4. **mysql-connector-python**
Driver oficial para conectarse a MySQL/MariaDB.

#### 5. **python-dotenv**
Carga variables de entorno desde archivo `.env`.

---

## 📁 Estructura del Proyecto

```
FerreApp/
├── app/
│   ├── __init__.py              
│   ├── main.py                  # 🎯 Endpoints (FastAPI)
│   ├── database.py              # 🗄️ Funciones CRUD (Repository)
│   └── __pycache__/            
│
├── docs/
│   └── init_db.sql              # 📜 Script inicialización BD
│
├── tests/
│   ├── test_fetch_all_productos.py
│   ├── test_insert_producto.py
│   └── ...                      # 🧪 Tests unitarios
│
├── 🐳 Dockerfile               # 🏗️ Receta para construir imagen de la API
├── 🐳 docker-compose.yml       # 🎼 Orquestador que levanta API + BD + Red
├── .env                         # 🔐 Variables de entorno (NO en Git)
├── .env.back                # 📋 Template de .env
├── requirements.txt             # 📦 Dependencias Python
└── README.md                    # 📖 Documentación
```

---

## � Docker y Containerización

### 🏗️ Arquitectura Obligatoria Implementada

Para cumplir con los estándares de la industria, la solución implementa una **arquitectura de microservicios mínima** compuesta por **tres pilares fundamentales**:

#### **1️⃣ Contenedor de la Aplicación Web (FastAPI)**

**Archivo:** `Dockerfile`

**Características:**
- ✅ **Aislamiento:** El código y sus dependencias residen exclusivamente dentro del contenedor
- ✅ **Variables de Entorno:** La API no tiene datos "hardcodeados"; lee la configuración de la BD desde el entorno de Docker
- ✅ **Reproducibilidad:** Funciona idénticamente en cualquier máquina que tenga Docker instalado
- ✅ **Host:** Escucha en `0.0.0.0` para ser accesible desde fuera del contenedor

#### **2️⃣ Contenedor de Base de Datos (MariaDB/MySQL)**

**Dentro de:** `docker-compose.yml` (servicio `db`)

**Características:**
- ✅ **Independencia:** Se ejecuta como un servicio separado, permitiendo escalar la BD de forma independiente
- ✅ **Persistencia:** Utiliza volúmenes de Docker (`db_data`) para asegurar que los datos NO se pierdan al apagar contenedores
- ✅ **Inicialización:** El script `init_db.sql` se carga automáticamente al iniciar por primera vez
- ✅ **Aislamiento de Red:** Solo la API puede conectarse mediante hostname `db`

#### **3️⃣ Red Docker (Bridge Network)**

**Creada automáticamente por:** `docker-compose.yml`

**Características:**
- ✅ **Comunicación Interna:** Los contenedores están unidos por una red privada virtual
- ✅ **Resolución por Nombre:** La API se conecta a la BD usando hostname `db` (nombre del servicio), eliminando la dependencia de IPs variables
- ✅ **Aislamiento:** La red Docker está aislada del host y otras aplicaciones
- ✅ **DNS Automático:** Docker proporciona resolución de nombres entre servicios

### 📋 Archivos Docker Clave

#### **Dockerfile - La Receta de la Imagen**
Define cómo construir la imagen de nuestra API de forma reproducible.

#### **docker-compose.yml - El Director de Orquesta**
El "director de orquesta" que levanta la API, la BD y crea la red que las une.

### 🎯 Requisitos para ejecución con Docker

✅ **Docker Desktop** instalado (incluye Docker Engine + Docker Compose)
- [Descargar Docker Desktop](https://www.docker.com/products/docker-desktop)
- Verificar: `docker --version && docker-compose --version`

---

## 🚀 Instalación y Despliegue (Quick Start)

### ⚡ El proyecto está optimizado para levantarse en menos de 60 segundos usando Docker

### 📋 Requisitos Previos

✅ **Docker Desktop** instalado y en ejecución
- [Descargar Docker Desktop](https://www.docker.com/products/docker-desktop)
- Verificar: `docker --version && docker-compose --version`

### 🎯 Pasos para el Despliegue

#### **Paso 1: Clonar y entrar**
```bash
git clone <url-repositorio>
cd practicaDockerExamen
```

#### **Paso 2: Levantar la infraestructura**
```bash
docker-compose up --build
```

**¡Listo!**

- **API:** http://localhost:8000
- **Documentación Interactiva:** http://localhost:8000/docs

---

### 🔧 Alternativa: Ejecución Local (Sin Docker)

> ⚠️ Nota: No recomendado para examen. Usa Docker para garantizar consistencia.

#### **Paso 1: Crear entorno virtual**

#### **Paso 1: Crear entorno virtual**
```bash
# Linux/Mac
python3 -m venv venv
source venv/bin/activate

# Windows
python -m venv venv
venv\Scripts\activate
```

#### **Paso 2: Instalar dependencias**
```bash
pip install -r requirements.txt
```

#### **Paso 2: Configurar .env**
```bash
cat > .env << EOF
DB_HOST=localhost
DB_USER=ferreapp
DB_PASSWORD=ferreapp123
DB_NAME=FerreApp
DB_PORT=3306
EOF
```

#### **Paso 3: Crear base de datos**
```bash
mysql -u root -p < docs/init_db.sql
```

#### **Paso 4: Ejecutar la aplicación**
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### **Acceder a la API:**
- **Swagger UI:** http://localhost:8000/docs
- **Productos:** http://localhost:8000/productos

---

## 📊 Comparativa de Opciones

| Aspecto | Docker | Local |
|--------|--------|-------|
| **Facilidad** | ⭐⭐⭐ | ⭐⭐ |
| **Consistencia** | ✅ Garantizada | ⚠️ Depende del host |
| **Dependencias** | 📦 Aisladas en contenedor | 📦 Instaladas en host |
| **Evaluación examen** | ✅ **RECOMENDADO** | ⚠️ Posibles problemas |
| **BD aislada** | ✅ Sí | ⚠️ Necesita MySQL local |
| **Limpieza** | ✅ `docker-compose down` | ⚠️ Manual |
| **Escalabilidad** | ✅ Fácil | ❌ Difícil |

---

## 🔌 Endpoints de la API

### 1. Health Check
```http
GET /ping
```
Respuesta: `{"message": "pong"}`

### 2. Listar todos los productos
```http
GET /productos
```
Respuesta: Lista de productos en JSON

### 3. Obtener un producto
```http
GET /productos/{id}
```
Respuesta: Producto específico o 404

### 4. Crear producto
```http
POST /productos
Content-Type: application/json

{
  "nombre": "Taladro",
  "descripcion": "Taladro profesional",
  "precio": 89.99,
  "stock": 5,
  "categoria": "Herramientas eléctricas",
  "codigo_sku": "TAL-1000W",
  "activo": true
}
```
Respuesta: **201 Created** con producto generado

### 5. Actualizar producto
```http
PUT /productos/{id}
Content-Type: application/json

{
  "nombre": "Martillo mejorado",
  "precio": 15.99,
  ...
}
```
Respuesta: Producto actualizado

### 6. Eliminar producto
```http
DELETE /productos/{id}
```
Respuesta: `{"mensaje": "Producto eliminado exitosamente", "id_producto": 1}`

---

## ✅ Validaciones Implementadas

| Campo | Validación | Ejemplo |
|-------|-----------|---------|
| `nombre` | min_length=1, max_length=80 | "Martillo 16oz" ✅ |
| `descripcion` | max_length=255 (opcional) | "Martillo..." ✅ |
| `precio` | ge=0 (>= 0) | 12.50 ✅ |
| `stock` | ge=0 (>= 0) | 25 ✅ |
| `categoria` | min_length=1, max_length=50 | "Herramientas" ✅ |
| `codigo_sku` | min_length=1, max_length=20 | "MART-16OZ" ✅ |

**Validadores personalizados:**
- `validar_nombre_categoria()`: No permite vacíos, trimea espacios
- `validar_codigo_sku()`: Convierte a mayúscula
- `validar_descripcion()`: Trimea espacios, None si está vacía

---

## 🎨 Patrones de Diseño Utilizados

### 1. **Repository Pattern** - Acceso a datos encapsulado
### 2. **Dependency Injection** - FastAPI inyecta automáticamente
### 3. **Data Transfer Objects (DTO)** - Modelos segregados por operación
### 4. **Layered Architecture** - Separación clara de capas

---

**Última actualización:** 6 de marzo de 2026  
**Versión:** 2.0.0 - Dockerizado para Examen

---

**¡Happy Coding! 🚀**
