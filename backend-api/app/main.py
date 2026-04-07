from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import projects
from app.routers import images


# *Instancia de FastAPI
app = FastAPI()

# *Configuración de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins = ["*"],
    allow_credentials = True,
    allow_methods = ["*"],
    allow_headers = ["*"],
)

# *Routers
app.include_router(projects.router)
app.include_router(images.router)

# *Endpoint root
@app.get("/")
def root():
    return {"message": "Hatchway API"}

