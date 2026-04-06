# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Hatchway** is a full-stack system with three interconnected components:
1. **`desktop-app/`** — Electron + React 18 + TypeScript desktop app (Windows/Mac/Linux)
2. **`backend-api/`** — FastAPI + PostgreSQL REST API, deployed on VPS via systemd (no Docker)
3. **`portfolio-updates/`** — React components/pages to integrate into an existing portfolio site

The desktop app manages developer projects, syncs them to the API, and the portfolio site fetches and displays them dynamically.

## Development Commands

### Backend API (FastAPI)
```bash
cd backend-api
source venv/bin/activate          # Windows: venv\Scripts\activate
uvicorn app.main:app --reload     # Dev server on :8000

# Database migrations
alembic revision --autogenerate -m "description"
alembic upgrade head

# Tests
pytest tests/
pytest tests/test_projects.py    # Single test file
```

### Desktop App (Electron + React)
```bash
cd desktop-app
pnpm install
pnpm dev        # Dev mode with hot reload
pnpm build      # Build React renderer
pnpm package    # Package into .exe/.dmg/.AppImage
```

### VPS / Deployment
```bash
journalctl -u hatchway-api -f    # Stream API logs
systemctl restart hatchway-api   # Restart API service
systemctl status hatchway-api
nginx -t && systemctl reload nginx
sudo -u postgres psql -c "\c hatchway"
```

## Architecture

### Data Flow
Desktop App → Zustand store → Axios → FastAPI (`:8000/api`) → SQLAlchemy → PostgreSQL  
Images → FastAPI → Cloudinary SDK → CDN URLs stored in DB  
Portfolio → `GET /api/projects?status=published` → React components

### Desktop App Structure (`desktop-app/src/`)
- `main/` — Electron main process (`main.ts`) and `preload.ts` (IPC bridge)
- `renderer/` — React app:
  - `api/client.ts` + `api/endpoints.ts` — Axios instance configured from `VITE_API_URL`
  - `store/projectStore.ts` + `store/settingsStore.ts` — Zustand stores
  - `types/project.ts` — shared TypeScript types (also used by forms/API)
  - `hooks/useProjects.ts`, `hooks/useImageUpload.ts` — custom hooks wrapping store + API
  - `components/projects/ProjectForm.tsx` — react-hook-form with zod validation, tabbed (General / Tech / Links / Images)

### Backend API Structure (`backend-api/app/`)
- `models/project.py` — SQLAlchemy model (source of truth for DB schema)
- `schemas/project.py` — Pydantic v2 schemas for request/response serialization
- `routers/projects.py` + `routers/images.py` — FastAPI route handlers
- `services/cloudinary.py` — image upload/delete wrapper
- `services/database.py` — DB session dependency
- `core/config.py` — settings loaded from `.env` via `python-dotenv`

### Key API Endpoints
- `GET /api/projects` — list with `?status=`, `?search=`, pagination
- `POST /api/projects` — create
- `GET /api/projects/{id}` / `PUT /api/projects/{id}` / `DELETE /api/projects/{id}`
- `GET /api/projects/slug/{slug}` — used by portfolio
- `POST /api/projects/{id}/images` — Cloudinary upload
- `DELETE /api/images/{public_id}` — Cloudinary delete
- `GET /api/docs` — Swagger UI (auto-generated)

### Project Status Flow
`draft` → `published` → `archived`  
Only `published` projects are fetched by the portfolio.

## Environment Variables

`desktop-app/.env`:
```
VITE_API_URL=https://your-domain.com
```

`backend-api/.env`:
```
DATABASE_URL=postgresql://user:pass@localhost/hatchway
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
```

## Tech Stack Quick Reference

| Layer | Key libs |
|-------|----------|
| Desktop UI | React 18, TailwindCSS, Zustand, react-hook-form, zod, react-dropzone, react-markdown, react-hot-toast |
| Electron | electron ^28, electron-builder, Vite |
| Backend | FastAPI, SQLAlchemy 2, Alembic, Pydantic v2, Cloudinary Python SDK, uvicorn |
| Deploy | systemd (`hatchway-api.service`), Nginx reverse proxy, Let's Encrypt |

## Git Commit Convention
```
feat(desktop): add markdown editor
fix(api): resolve CORS issue
docs: update deployment guide
```
Scope options: `desktop`, `api`, `portfolio`

## CORS
FastAPI must whitelist Electron's origin. Electron renderer pages load from `file://` or a custom protocol — configure `allow_origins` in `app/main.py` accordingly for both dev and production.

## VPS Deployment (No Docker)
API runs as a systemd service at `/var/www/hatchway-api`. Full setup guide planned at `docs/deployment-vps.md`. The service file template is at `backend-api/hatchway-api.service`. Use `screen` or `tmux` during deploy to survive SSH disconnects.
