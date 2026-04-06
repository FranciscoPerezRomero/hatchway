from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.project import Project
from app.schemas.project import ProjectCreate, ProjectResponse

router = APIRouter(prefix="/api/projects", tags=["projects"])


# *Aquí se usa la inyección de dependencias
@router.get("/", response_model=list[ProjectResponse])
def get_projects(db: Session = Depends(get_db)):
    projects = db.query(Project).all()
    return projects

# *Obetener un proyecto
@router.get("/{project_id}",response_model=ProjectResponse)
def get_project(project_id: int, db:Session = Depends(get_db)):
    project = db.query(Project).filter(Project.id == project_id).first()
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return project

# *Crear proyecto
@router.post("/", response_model=ProjectResponse)
def create_project(project: ProjectCreate, db: Session = Depends(get_db)):

    # *Conversión objeto Pydantic a diccionario
    # *Los dos ** lo desempaquetan como argumentos
    db_project = Project(**project.model_dump())
    existing = db.query(Project).filter(Project.slug == project.slug).first()
    if existing:
        raise HTTPException(status_code=409, detail="Slug already exists")
    db.add(db_project)
    db.commit()
    db.refresh(db_project)
    return db_project


# *Actualizar un proyecto
@router.put("/{project_id}", response_model=ProjectResponse)
def update_project (project_id: int,project: ProjectCreate, db: Session = Depends(get_db)):
    db_project = db.query(Project).filter(Project.id == project_id).first()
    if db_project is None:
        raise HTTPException(status_code=404, detail = "Project not found")
    for key, value in project.model_dump(exclude_unset=True).items():
        setattr(db_project, key, value)
    db.commit()
    db.refresh(db_project)
    return db_project

# *Eliminar un proyecto
@router.delete("/{project_id}", response_model=ProjectResponse)
def delete_project(project_id: int, db: Session = Depends(get_db)):
    db_project = db.query(Project).filter(Project.id == project_id).first()
    if db_project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    db.delete(db_project)
    db.commit()
    return {"message":"Project deleted"}




