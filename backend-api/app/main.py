from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import projects

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

# *Router
app.include_router(projects.router)

# *Endpoint root
@app.get("/")
def root():
    return {"message": "Hatchway API"}

