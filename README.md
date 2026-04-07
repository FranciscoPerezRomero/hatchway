# Hatchway

> *"The gateway to your portfolio"*

Sistema integral para gestionar proyectos de desarrollo con sincronización automática a portafolio web mediante API REST.

## Componentes

| Componente | Tecnología | Estado |
|------------|-----------|--------|
| `backend-api/` | FastAPI + PostgreSQL | ✅ Completo |
| `desktop-app/` | Electron + React + TypeScript | 🔜 Próximamente |
| `portfolio-updates/` | React | 🔜 Próximamente |

## Requisitos

- Python 3.13+
- PostgreSQL 16+
- Node.js 20+ / pnpm
- Poetry

## Setup local — Backend API

```bash
cd backend-api

# Instalar dependencias
poetry install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales

# Crear base de datos
psql -U postgres -c "CREATE DATABASE hatchway;"
psql -U postgres -c "CREATE USER hatchway_user WITH PASSWORD 'hatchway_pass';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE hatchway TO hatchway_user;"

# Ejecutar migraciones
poetry run alembic upgrade head

# Iniciar servidor
poetry run uvicorn app.main:app --reload
```

API disponible en `http://localhost:8000` — documentación en `http://localhost:8000/docs`

## Variables de entorno

Crea `backend-api/.env` basándote en este ejemplo:

```
DATABASE_URL=postgresql://hatchway_user:hatchway_pass@localhost:5432/hatchway
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

## Endpoints principales

```
GET    /api/projects                      Lista proyectos
POST   /api/projects                      Crea proyecto
GET    /api/projects/{id}                 Obtiene uno
PUT    /api/projects/{id}                 Actualiza
DELETE /api/projects/{id}                 Elimina
POST   /api/projects/{id}/images          Sube imagen a Cloudinary
DELETE /api/images/{public_id}            Elimina imagen de Cloudinary
```

## Arquitectura

```
Desktop App → Axios → FastAPI → SQLAlchemy → PostgreSQL
                                    ↓
                              Cloudinary (imágenes)
                                    ↑
Portfolio ← GET /api/projects?status=published
```

## Licencia

MIT
