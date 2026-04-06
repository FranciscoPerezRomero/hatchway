# Hatchway - Plan Maestro del Proyecto

> **Desktop Application + REST API + Portfolio Integration**  
> Sistema integral para gestionar proyectos de desarrollo con sincronización automática a portafolio web mediante API REST.  
> Deploy: Electron Desktop App (Windows/Mac/Linux) + FastAPI en VPS + React Portfolio actualizado

**Tagline:** *"The gateway to your portfolio"*

---

## 📋 Información del Proyecto

| Campo | Detalle |
|-------|---------|
| **Nombre** | Hatchway |
| **Tipo** | Desktop Application + REST API + Web Integration |
| **Objetivo** | Crear un sistema centralizado para gestionar proyectos de desarrollo que se sincronice automáticamente con un portafolio web dinámico |
| **Problema que resuelve** | Actualizar manualmente el portafolio cada vez que se completa un proyecto es tedioso, propenso a errores y no escala |
| **Usuario objetivo** | Desarrolladores que mantienen portafolio personal y quieren automatizar la publicación de proyectos |
| **Tecnologías principales** | Electron, React, TypeScript, FastAPI, PostgreSQL, React Router |
| **Deploy/Distribución** | Electron Builder (Desktop) + VPS sin Docker (API) + Nginx (Portfolio) |
| **Repositorio** | https://github.com/[tu-username]/hatchway |
| **Versión objetivo MVP** | v1.0.0 |
| **Fecha inicio** | 31 de Marzo 2025 |
| **Fecha estimada MVP** | 18 de Abril 2025 (2.5 semanas) |

---

## 🎯 Alcance del Proyecto

### Funcionalidades Core (MVP - v1.0.0)

| # | Funcionalidad | Descripción | Prioridad |
|---|---------------|-------------|-----------|
| 1 | CRUD de Proyectos | Crear, leer, actualizar y eliminar proyectos con todos sus campos | 🔴 Crítica |
| 2 | Upload de Imágenes | Subir thumbnail, hero image y screenshots a Cloudinary | 🔴 Crítica |
| 3 | Conexión con API | Sincronizar proyectos entre desktop app y backend API | 🔴 Crítica |
| 4 | Preview Local | Visualizar cómo se verá el proyecto en el portafolio antes de publicar | 🟡 Media |
| 5 | Gestión de Estado | Sistema para marcar proyectos como draft, published, archived | 🔴 Crítica |
| 6 | Markdown Editor | Editor con preview para description del proyecto | 🟡 Media |
| 7 | Tags & Categories | Sistema de etiquetado y categorización | 🟡 Media |
| 8 | Search & Filter | Buscar y filtrar proyectos en la app desktop | 🟢 Baja |

### Funcionalidades Futuras (Fase 2 - v2.0.0)

| # | Funcionalidad | Descripción | Prioridad |
|---|---------------|-------------|-----------|
| 1 | Auto-sync GitHub | Obtener stats automáticamente de GitHub API (stars, forks, etc.) | 🟡 Media |
| 2 | Analytics Integration | Ver estadísticas de visitas a cada proyecto desde el portafolio | 🟢 Baja |
| 3 | Templates de Proyecto | Plantillas predefinidas (Frontend, Backend, Fullstack, etc.) | 🟢 Baja |
| 4 | Multi-idioma | Gestionar contenido en inglés y español | 🟡 Media |
| 5 | Blog Integration | Vincular posts de blog con proyectos | 🟢 Baja |
| 6 | Export/Import | Exportar proyectos a JSON/Markdown para backup | 🟢 Baja |

**Leyenda de prioridades:**
- 🔴 Crítica: Sin esto el MVP no funciona
- 🟡 Media: Importante pero no bloqueante
- 🟢 Baja: Nice-to-have para MVP

---

## 🛠️ Stack Tecnológico

### Desktop Application (Frontend)

| Tecnología | Versión | Propósito | Justificación |
|------------|---------|-----------|---------------|
| **Electron** | ^28.0.0 | Framework para app desktop | Cross-platform, maduro, excelente ecosistema |
| **React** | ^18.2.0 | UI library | Componentes reutilizables, virtual DOM eficiente |
| **TypeScript** | ^5.3.0 | Lenguaje | Type safety, mejor DX, menos bugs |
| **TailwindCSS** | ^3.4.0 | Styling | Utility-first, rápido, consistente, temas fáciles |
| **Zustand** | ^4.5.0 | State management | Ligero, simple, mejor que Redux para este caso |
| **React Hook Form** | ^7.50.0 | Form handling | Validación, performance, UX |
| **Axios** | ^1.6.0 | HTTP client | Comunicación con API backend |

### Backend API

| Tecnología | Versión | Propósito | Justificación |
|------------|---------|-----------|---------------|
| **FastAPI** | ^0.109.0 | Web framework | Rápido, async, auto-documentación |
| **PostgreSQL** | 15+ | Database | Robusto, JSON nativo, relaciones complejas |
| **SQLAlchemy** | ^2.0.0 | ORM | Abstracción de DB, migrations |
| **Alembic** | ^1.13.0 | Migrations | Versionado de esquema DB |
| **Pydantic** | ^2.5.0 | Validación | Type safety, serialización automática |
| **Cloudinary** | Python SDK | Image storage | CDN global, transformaciones automáticas |
| **uvicorn** | ^0.27.0 | ASGI server | Servidor de producción para FastAPI |
| **python-dotenv** | ^1.0.0 | Variables de entorno | Gestión de configuración |

### Portfolio Frontend (EXISTENTE - solo actualizaciones menores)

| Tecnología | Versión | Propósito | Notas |
|------------|---------|-----------|-------|
| **React** | Actual | UI library | Ya instalado en tu proyecto |
| **React Router** | v6 | Routing | Ya instalado y configurado |
| **TailwindCSS** | Actual o nuevo | Styling | Si no lo tienes, lo agregamos |
| **Axios** | ^1.6.0 | HTTP client | Para fetch de API |

### Librerías Adicionales

| Librería | Versión | Propósito |
|----------|---------|-----------|
| **react-markdown** | ^9.0.0 | Renderizar markdown en preview |
| **react-dropzone** | ^14.2.0 | Upload de imágenes drag & drop |
| **date-fns** | ^3.3.0 | Manejo de fechas |
| **zod** | ^3.22.0 | Validación de schemas |
| **lucide-react** | ^0.323.0 | Iconos consistentes |
| **framer-motion** | ^11.0.0 | Animaciones fluidas (opcional) |
| **react-hot-toast** | ^2.4.0 | Notificaciones toast |

### Tooling

| Herramienta | Propósito |
|-------------|-----------|
| **Vite** | Build tool rápido para Electron + React |
| **electron-builder** | Empaquetar .exe, .dmg, .AppImage |
| **Prettier** | Code formatting |
| **ESLint** | Linting |
| **systemd** | Gestión de servicio API en VPS (en lugar de Docker) |
| **Nginx** | Reverse proxy y servidor estático |

---

## 📁 Estructura de Carpetas
```
hatchway/
├── desktop-app/                 # Electron + React app
│   ├── src/
│   │   ├── main/               # Electron main process
│   │   │   ├── main.ts
│   │   │   └── preload.ts
│   │   ├── renderer/           # React app
│   │   │   ├── components/
│   │   │   │   ├── layout/
│   │   │   │   │   ├── Sidebar.tsx
│   │   │   │   │   ├── Header.tsx
│   │   │   │   │   └── Layout.tsx
│   │   │   │   ├── projects/
│   │   │   │   │   ├── ProjectForm.tsx
│   │   │   │   │   ├── ProjectList.tsx
│   │   │   │   │   ├── ProjectCard.tsx
│   │   │   │   │   └── ProjectDetail.tsx
│   │   │   │   ├── common/
│   │   │   │   │   ├── ImageUploader.tsx
│   │   │   │   │   ├── MarkdownEditor.tsx
│   │   │   │   │   ├── SearchBar.tsx
│   │   │   │   │   └── StatusBadge.tsx
│   │   │   │   └── ui/
│   │   │   │       ├── Button.tsx
│   │   │   │       ├── Input.tsx
│   │   │   │       └── Modal.tsx
│   │   │   ├── pages/
│   │   │   │   ├── Dashboard.tsx
│   │   │   │   ├── ProjectEdit.tsx
│   │   │   │   └── Settings.tsx
│   │   │   ├── store/
│   │   │   │   ├── projectStore.ts
│   │   │   │   └── settingsStore.ts
│   │   │   ├── api/
│   │   │   │   ├── client.ts
│   │   │   │   └── endpoints.ts
│   │   │   ├── types/
│   │   │   │   ├── project.ts
│   │   │   │   └── api.ts
│   │   │   ├── hooks/
│   │   │   │   ├── useProjects.ts
│   │   │   │   └── useImageUpload.ts
│   │   │   ├── utils/
│   │   │   │   ├── validators.ts
│   │   │   │   └── formatters.ts
│   │   │   ├── App.tsx
│   │   │   └── index.tsx
│   │   └── assets/
│   │       ├── icons/
│   │       └── images/
│   ├── package.json
│   ├── tsconfig.json
│   ├── vite.config.ts
│   ├── electron-builder.config.js
│   ├── tailwind.config.js
│   └── .env.example
│
├── backend-api/                 # FastAPI backend
│   ├── app/
│   │   ├── models/
│   │   │   ├── __init__.py
│   │   │   └── project.py
│   │   ├── schemas/
│   │   │   ├── __init__.py
│   │   │   └── project.py
│   │   ├── routers/
│   │   │   ├── __init__.py
│   │   │   ├── projects.py
│   │   │   └── images.py
│   │   ├── services/
│   │   │   ├── __init__.py
│   │   │   ├── cloudinary.py
│   │   │   └── database.py
│   │   ├── core/
│   │   │   ├── __init__.py
│   │   │   ├── config.py
│   │   │   └── security.py
│   │   ├── database.py
│   │   └── main.py
│   ├── alembic/
│   │   ├── versions/
│   │   └── env.py
│   ├── tests/
│   │   └── test_projects.py
│   ├── requirements.txt
│   ├── hatchway-api.service      # systemd service file
│   └── .env.example
│
├── portfolio-updates/           # Cambios para tu portfolio existente
│   ├── components/
│   │   ├── ProjectCard.jsx      # Nuevo componente
│   │   └── ProjectDetail.jsx    # Nuevo componente
│   ├── pages/
│   │   ├── Projects.jsx         # Actualizar existente
│   │   └── ProjectPage.jsx      # Nueva página dinámica
│   ├── api/
│   │   └── projects.js          # Helper para fetch
│   └── INTEGRATION.md           # Instrucciones de integración
│
├── docs/
│   ├── api-documentation.md
│   ├── deployment-vps.md        # Guía específica sin Docker
│   └── user-guide.md
│
├── .gitignore
├── README.md
└── PLAN.md
```

**Descripción de carpetas clave:**
- `desktop-app/`: App Electron completa
- `backend-api/`: API FastAPI para deploy en VPS
- `portfolio-updates/`: Solo los archivos nuevos/modificados para tu portfolio
- `docs/deployment-vps.md`: Guía paso a paso para deploy SIN Docker

---

## 🗺️ Roadmap de Desarrollo (2.5 Semanas)

### Semana 1: Backend API + VPS Setup
**Objetivo:** API REST funcional con PostgreSQL en VPS

**Días 1-2: Desarrollo Local**
- [ ] Setup inicial del proyecto FastAPI en local
- [ ] Instalar PostgreSQL localmente (Windows: installer, Mac: Homebrew)
- [ ] Crear modelos SQLAlchemy para Project
- [ ] Crear schemas Pydantic (request/response)
- [ ] Configurar Alembic para migraciones
- [ ] Primera migración (crear tabla projects)

**Días 3-4: CRUD Endpoints**
- [ ] Implementar endpoint `POST /api/projects` (crear)
- [ ] Implementar endpoint `GET /api/projects` (listar con paginación)
- [ ] Implementar endpoint `GET /api/projects/{id}` (obtener uno)
- [ ] Implementar endpoint `PUT /api/projects/{id}` (actualizar)
- [ ] Implementar endpoint `DELETE /api/projects/{id}` (eliminar)
- [ ] Agregar filtros y búsqueda en GET /api/projects
- [ ] Testing local con Thunder Client/Postman

**Días 5-7: Cloudinary & Deploy en VPS**
- [ ] Integrar Cloudinary SDK
- [ ] Endpoint `POST /api/projects/{id}/images` (upload)
- [ ] Endpoint `DELETE /api/images/{public_id}` (eliminar imagen)
- [ ] Configurar CORS para permitir requests desde Electron
- [ ] Documentación automática con Swagger

**Deploy en VPS (SIN Docker):**
- [ ] SSH al VPS: `ssh root@tu-vps.com`
- [ ] Instalar PostgreSQL 15: `apt install postgresql postgresql-contrib`
- [ ] Crear base de datos y usuario
- [ ] Instalar Python 3.11: `apt install python3.11 python3.11-venv`
- [ ] Clonar repo en `/var/www/hatchway-api`
- [ ] Crear venv y instalar dependencias
- [ ] Configurar variables de entorno (.env)
- [ ] Ejecutar migraciones: `alembic upgrade head`
- [ ] Crear servicio systemd: `/etc/systemd/system/hatchway-api.service`
- [ ] Iniciar servicio: `systemctl start hatchway-api`
- [ ] Configurar Nginx reverse proxy (puerto 8000 → /api)
- [ ] Configurar HTTPS con Let's Encrypt (Certbot)
- [ ] Verificar API funcionando: `https://tu-dominio.com/api/docs`

### Semana 2: Desktop App (Electron + React)
**Objetivo:** App desktop funcional que consume la API

**Días 1-2: Setup & Layout**
- [ ] Setup proyecto Electron + Vite + React + TypeScript
- [ ] Configurar TailwindCSS con tema personalizado
- [ ] Crear componente Layout con Sidebar
- [ ] Implementar Zustand store para proyectos
- [ ] Crear axios client configurado para API
- [ ] Configurar variables de entorno (.env)

**Días 3-4: Lista de Proyectos**
- [ ] Componente ProjectList con grid responsivo
- [ ] Componente ProjectCard con info básica
- [ ] Integrar fetch de proyectos desde API
- [ ] Loading states y skeleton loaders
- [ ] SearchBar con filtro local
- [ ] Filtros por status y categoría

**Días 5-7: Formulario & Upload**
- [ ] Componente ProjectForm completo
- [ ] Integrar react-hook-form con validación
- [ ] Tabs para organizar campos (General, Tech, Links, Images)
- [ ] Componente ImageUploader con react-dropzone
- [ ] Upload de imágenes a API → Cloudinary
- [ ] Preview de imágenes subidas
- [ ] Markdown editor con preview (react-markdown)
- [ ] Modal de confirmación para eliminar
- [ ] Toast notifications con react-hot-toast
- [ ] Página de detalle de proyecto con edición inline

**Día 7: Build & Testing**
- [ ] Configurar electron-builder
- [ ] Build con electron-builder
- [ ] Testing de .exe en Windows
- [ ] Fix de bugs encontrados

### Semana 3 (Solo 4 días): Portfolio Integration
**Objetivo:** Portfolio consume API y muestra proyectos dinámicamente

**Día 1: Preparación**
- [ ] Crear branch `feature/dynamic-projects` en repo del portfolio
- [ ] Instalar axios si no está: `npm install axios`
- [ ] Crear archivo `src/api/projects.js` con helpers

**Ejemplo `src/api/projects.js`:**
```javascript
import axios from 'axios'

const API_URL = 'https://tu-dominio.com/api'

export const fetchProjects = async (status = 'published') => {
  const response = await axios.get(`${API_URL}/projects`, {
    params: { status }
  })
  return response.data
}

export const fetchProjectBySlug = async (slug) => {
  const response = await axios.get(`${API_URL}/projects/slug/${slug}`)
  return response.data
}
```

**Día 2: Componentes**
- [ ] Crear componente `src/components/ProjectCard.jsx`
- [ ] Crear componente `src/components/ProjectDetail.jsx`
- [ ] Agregar estilos con TailwindCSS (si usas, si no, CSS módulos)

**Ejemplo `ProjectCard.jsx`:**
```jsx
export default function ProjectCard({ project }) {
  return (
    <div className="border rounded-lg p-6 hover:shadow-lg transition">
      <img src={project.thumbnail_url} alt={project.title} />
      <h3 className="text-xl font-bold mt-4">{project.title}</h3>
      <p className="text-gray-600 mt-2">{project.tagline}</p>
      <div className="flex gap-2 mt-4">
        {project.tech_stack.map(tech => (
          <span key={tech} className="px-2 py-1 bg-blue-100 rounded text-sm">
            {tech}
          </span>
        ))}
      </div>
      <Link to={`/projects/${project.slug}`}>Ver más →</Link>
    </div>
  )
}
```

**Día 3: Páginas**
- [ ] Actualizar `src/pages/Projects.jsx` (reemplazar datos hardcoded)
- [ ] Crear `src/pages/ProjectPage.jsx` (página dinámica con `:slug`)
- [ ] Agregar rutas en React Router

**Ejemplo actualización en `App.jsx`:**
```jsx
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Projects from './pages/Projects'
import ProjectPage from './pages/ProjectPage'

function App() {
  return (
    <Routes>
      {/* Tus rutas existentes */}
      <Route path="/projects" element={<Projects />} />
      <Route path="/projects/:slug" element={<ProjectPage />} />
    </Routes>
  )
}
```

**Día 4: Testing & Deploy**
- [ ] Testing local de integración completa
- [ ] Build del portfolio: `npm run build`
- [ ] Subir build a VPS (rsync o scp)
- [ ] Verificar Nginx sirve el nuevo build
- [ ] Testing en producción
- [ ] Fix de bugs encontrados

---

## ✅ TODO List General

### Setup Inicial
- [ ] Crear carpeta `hatchway`
- [ ] Inicializar git: `git init`
- [ ] Crear repositorio `hatchway` en GitHub
- [ ] Crear `.gitignore` completo (Node, Python, .env)
- [ ] Obtener credenciales de Cloudinary (free tier)
- [ ] Verificar acceso SSH a VPS

### Desarrollo
- [ ] Completar Semana 1 (Backend API + Deploy VPS)
- [ ] Completar Semana 2 (Desktop App)
- [ ] Completar Semana 3 (Portfolio Integration)

### Testing
- [ ] CRUD completo funciona desde desktop app
- [ ] Imágenes se suben correctamente a Cloudinary
- [ ] API responde correctamente en VPS
- [ ] Portfolio muestra proyectos dinámicamente
- [ ] Filtros y búsqueda funcionan
- [ ] Markdown se renderiza correctamente
- [ ] Testing en Windows (desktop app)
- [ ] Testing en navegadores (Chrome, Firefox, Safari)

### Deploy/Distribución
- [ ] API corriendo en VPS con systemd
- [ ] PostgreSQL funcionando en VPS
- [ ] Nginx configurado como reverse proxy
- [ ] HTTPS con Let's Encrypt
- [ ] Portfolio actualizado en VPS
- [ ] Build de desktop app para Windows (.exe)
- [ ] Subir release a GitHub
- [ ] Verificar todo en producción

### Documentación
- [ ] README con instrucciones de instalación (API)
- [ ] README con instrucciones de desarrollo local
- [ ] README con instrucciones de uso (Desktop app)
- [ ] README con screenshots del proyecto
- [ ] README con diagrama de arquitectura
- [ ] Guía de deployment sin Docker (`docs/deployment-vps.md`)
- [ ] API documentation en `/api/docs` (Swagger auto-generado)
- [ ] Video demo grabado y subido
- [ ] Actualizar portafolio con Hatchway

---

## 📊 Requerimientos Técnicos

### Requerimientos del Sistema (Desarrollo)

| Componente | Requerimiento Mínimo | Recomendado |
|------------|---------------------|-------------|
| **Sistema Operativo** | Windows 10, macOS 10.15, Ubuntu 20.04 | Windows 11, macOS 13+, Ubuntu 22.04 |
| **Node.js** | 18.0+ | 20.0+ LTS |
| **npm/pnpm** | npm 9.0+ | pnpm 8.0+ (más rápido) |
| **Python** | 3.10+ | 3.11+ |
| **PostgreSQL** | 13+ (local) | 15+ |
| **RAM** | 8GB | 16GB+ |
| **Espacio en disco** | 5GB | 10GB+ |
| **Editor** | Cualquier editor de texto | VSCode con extensiones |

### Extensiones VSCode Recomendadas

- **ESLint** (dbaeumer.vscode-eslint)
- **Prettier** (esbenp.prettier-vscode)
- **Tailwind CSS IntelliSense** (bradlc.vscode-tailwindcss)
- **Python** (ms-python.python)
- **Thunder Client** (rangav.vscode-thunder-client) - Testing de API
- **GitLens** (eamodio.gitlens)
- **Error Lens** (usernamehw.errorlens)

### Requerimientos del VPS

| Componente | Requerimiento |
|------------|---------------|
| **Sistema Operativo** | Ubuntu 20.04+ o Debian 11+ |
| **RAM** | 2GB mínimo, 4GB recomendado |
| **Espacio en disco** | 20GB mínimo |
| **CPU** | 1 core mínimo, 2 cores recomendado |
| **Acceso** | SSH root o sudo |
| **Software** | Nginx, PostgreSQL 15, Python 3.11, Certbot |

### Requerimientos del Usuario Final

| Componente | Requerimiento |
|------------|---------------|
| **Sistema Operativo** | Windows 10+, macOS 10.15+, Linux (Ubuntu 20.04+, Fedora, etc.) |
| **RAM** | 4GB mínimo, 8GB recomendado |
| **Espacio en disco** | 500MB para la app |
| **Conexión a internet** | Requerida para sincronizar con API |
| **Resolución de pantalla** | 1366x768 mínimo, 1920x1080 recomendado |

---

## 🚫 Problemas Potenciales y Soluciones

| # | Problema Potencial | Solución Preventiva | Plan de Contingencia |
|---|-------------------|---------------------|----------------------|
| 1 | **CORS errors desde Electron** | Configurar CORS correctamente en FastAPI desde el inicio | Usar proxy en Electron o whitelist específico |
| 2 | **PostgreSQL cae en VPS** | Configurar auto-restart con systemd, monitoreo | Backup diario automático con cron, restore rápido |
| 3 | **Cloudinary alcanza límite free** | Monitorear uso, comprimir imágenes antes | Migrar a alternativa o upgrade de plan |
| 4 | **systemd service no inicia** | Verificar permisos, paths absolutos en .service | Ver logs con `journalctl -u hatchway-api` |
| 5 | **Nginx reverse proxy falla** | Testing de config con `nginx -t` antes de reload | Rollback a config anterior |
| 6 | **Electron app muy pesada** | Usar asar, excluir devDependencies | Aceptar tamaño (normal en Electron) |
| 7 | **Portfolio no actualiza** | Clear cache del navegador, hard refresh | Verificar que build se subió correctamente |
| 8 | **Migration rompe datos** | Backup antes de migrate, testing en local | Rollback de migración, restore de backup |
| 9 | **API lenta con muchos proyectos** | Paginación, índices en DB | Query optimization |
| 10 | **Pérdida de conexión SSH durante deploy** | Usar `screen` o `tmux` | Reconectar y verificar estado |

---

## 🎨 Decisiones de Diseño

### Paleta de Colores
```css
:root {
  /* Primary - Nautical Blue (Hatchway theme) */
  --primary-50: #eff6ff;
  --primary-100: #dbeafe;
  --primary-500: #3b82f6;   /* Main primary */
  --primary-600: #2563eb;
  --primary-900: #1e3a8a;
  
  /* Accent - Ocean Teal */
  --accent-500: #06b6d4;
  
  /* Success, Warning, Error */
  --success: #10b981;
  --warning: #f59e0b;
  --error: #ef4444;
  
  /* Neutrals */
  --bg-primary: #ffffff;
  --bg-secondary: #f9fafb;
  --text-primary: #111827;
  --text-secondary: #6b7280;
  --border: #e5e7eb;
}

/* Dark mode */
.dark {
  --bg-primary: #0f172a;
  --bg-secondary: #1e293b;
  --text-primary: #f1f5f9;
  --text-secondary: #94a3b8;
  --border: #334155;
}
```

### Tipografía

- **Fuente principal:** Inter o la que ya uses en tu portfolio
- **Fuente monospace:** JetBrains Mono para code blocks

---

## 📈 Métricas de Éxito

### Criterios Técnicos
- [ ] API responde en <200ms para CRUD
- [ ] Desktop app inicia en <3 segundos
- [ ] Upload de imagen <5 segundos
- [ ] Portfolio carga en <1 segundo
- [ ] Zero errores TypeScript en build

### Criterios de Funcionalidad
- [ ] Crear proyecto completo en <2 minutos
- [ ] Imágenes se muestran correctamente
- [ ] Markdown renderiza correctamente
- [ ] Filtros funcionan instantáneamente
- [ ] Sincronización sin pérdida de datos

### Criterios de Portafolio
- [ ] Dominio de Electron + React + TypeScript
- [ ] Dominio de FastAPI + PostgreSQL
- [ ] Código limpio y documentado
- [ ] README profesional
- [ ] Video demo
- [ ] Deploy en vivo

---

## 🔗 Recursos y Referencias

### Documentación Oficial
- [Electron Docs](https://www.electronjs.org/docs/latest)
- [FastAPI Docs](https://fastapi.tiangolo.com)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [React Router v6](https://reactrouter.com/en/main)
- [Cloudinary Docs](https://cloudinary.com/documentation)

### Deployment Sin Docker
- [Deploying FastAPI without Docker](https://fastapi.tiangolo.com/deployment/manually/)
- [systemd Service Tutorial](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Nginx Reverse Proxy Guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [PostgreSQL Ubuntu Setup](https://www.postgresql.org/download/linux/ubuntu/)

### Herramientas
- [Thunder Client](https://www.thunderclient.com)
- [DBeaver](https://dbeaver.io) - PostgreSQL client
- [FileZilla](https://filezilla-project.org/) - SFTP alternativa

---

## 📝 Notas de Desarrollo

### Convenciones de Código
```typescript
// TypeScript/JavaScript
const ProjectCard: React.FC<Props> = ({ project }) => { ... }
const handleSubmit = async () => { ... }

interface Project { ... }
type ProjectStatus = 'draft' | 'published' | 'archived'
```
```python
# Python
class Project(Base):
    __tablename__ = "projects"

def get_project_by_slug(db: Session, slug: str):
    return db.query(Project).filter(Project.slug == slug).first()
```

### Git Commit Convention
```
feat(desktop): add markdown editor
fix(api): resolve CORS issue
docs: update deployment guide
```

---

## 🚀 Comandos Útiles
```bash
# ===== DESKTOP APP =====
cd desktop-app
pnpm install
pnpm dev
pnpm build
pnpm package

# ===== BACKEND API LOCAL =====
cd backend-api
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload

# Migraciones
alembic revision --autogenerate -m "descripción"
alembic upgrade head

# ===== VPS =====
# Conectar
ssh root@tu-vps.com

# Ver logs de API
journalctl -u hatchway-api -f

# Reiniciar servicio
systemctl restart hatchway-api

# Ver status
systemctl status hatchway-api

# PostgreSQL
sudo -u postgres psql
\c hatchway
\dt

# Nginx
nginx -t
systemctl reload nginx

# ===== PORTFOLIO =====
cd portfolio
npm run build
scp -r build/* root@tu-vps.com:/var/www/portfolio/
```

---

## 🐛 Debugging Tips

### API no responde en VPS
```bash
# Ver logs
journalctl -u hatchway-api -n 50

# Verificar que corre
systemctl status hatchway-api

# Probar directamente
curl http://localhost:8000/api/projects

# Verificar PostgreSQL
sudo systemctl status postgresql
```

### Electron no conecta con API
```bash
# Abrir DevTools en Electron: Ctrl+Shift+I
# Ver Console y Network tabs

# Verificar .env
cat desktop-app/.env
# VITE_API_URL=https://tu-dominio.com
```

---

## 📞 Contacto y Soporte

**Desarrollador:** [Tu Nombre]  
**GitHub:** https://github.com/[tu-username]  
**Repositorio:** https://github.com/[tu-username]/hatchway

---

## 📄 Licencia

MIT License - Uso libre

---

**Última actualización:** 31 de Marzo 2025  
**Versión del documento:** 1.0.1 (Ajustado para deployment sin Docker)  
**Estado del proyecto:** 🚧 En desarrollo

---

## 🎯 Quick Start (Sin Docker)

### Desarrollo Local
```bash
# 1. Backend
cd backend-api
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
# Instalar PostgreSQL local
# Windows: https://www.postgresql.org/download/windows/
# Mac: brew install postgresql
createdb hatchway
alembic upgrade head
uvicorn app.main:app --reload

# 2. Desktop App
cd desktop-app
pnpm install
pnpm dev
```

### Deploy en VPS (Sin Docker)

Ver guía completa en `docs/deployment-vps.md` (la crearemos en Semana 1)

**Pasos resumidos:**
1. Instalar PostgreSQL 15
2. Crear database y user
3. Instalar Python 3.11
4. Clonar repo y setup venv
5. Configurar systemd service
6. Configurar Nginx reverse proxy
7. Setup HTTPS con Certbot

---

**🎉 ¡Hatchway está listo para comenzar!**