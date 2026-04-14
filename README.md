# Hatchway

> *"The gateway to your portfolio"*

Sistema integral para gestionar proyectos de desarrollo con sincronización automática a portafolio web mediante API REST.

## Componentes

| Componente | Tecnología | Estado |
|------------|-----------|--------|
| `backend-api/` | FastAPI + PostgreSQL | ✅ Completo |
| `desktop-app/` | Electron + React + TypeScript | 🚧 En desarrollo |
| `portfolio-updates/` | React | 🔜 Próximamente |

## Requisitos

- Python 3.13+
- PostgreSQL 16+
- Node.js 20+ / pnpm 9+
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

## Setup local — Desktop App

```bash
cd desktop-app
pnpm install
pnpm dev        # Abre la ventana de Electron con hot reload
```

Requiere que el backend esté corriendo en `http://localhost:8000`. Configura `desktop-app/.env`:

```
VITE_API_URL=http://localhost:8000
```

### Funcionalidades implementadas

- Listado de proyectos en grilla con tarjetas por estado
- Formulario de creación con validación (react-hook-form + zod)
  - Título, slug, tagline, descripción, status
  - Tech stack con tags dinámicos
  - URLs: GitHub, live, demo
- Modal reutilizable con scroll interno

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
