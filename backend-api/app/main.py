from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import projects
from app.routers import images
from app.routers import posts
from app.routers import price_catalog
from app.routers import quotes


# *Instancia de FastAPI
app = FastAPI()

# *Configuración de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# *Routers
app.include_router(projects.router)
app.include_router(images.router)
app.include_router(posts.router)
app.include_router(price_catalog.router)
app.include_router(quotes.router)

# *Endpoint root
@app.get("/")
def root():
    return {"message": "Hatchway API"}

