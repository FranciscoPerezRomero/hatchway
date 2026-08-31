from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.models.project import Project
from app.schemas.project import ProjectCreate, ProjectResponse, AdjacentResponse, AdjacentProject

router = APIRouter(prefix="/api/projects", tags=["projects"])


# *Listado con filtros opcionales — ordenado por 'order' ascendente
@router.get("/", response_model=list[ProjectResponse])
def get_projects(
    is_published: Optional[bool] = Query(None),
    is_featured: Optional[bool] = Query(None),
    project_type: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    query = db.query(Project)
    if is_published is not None:
        query = query.filter(Project.is_published == is_published)
    if is_featured is not None:
        query = query.filter(Project.is_featured == is_featured)
    if project_type:
        query = query.filter(Project.project_type == project_type)
    return query.order_by(Project.order.asc()).all()


# *Proyectos adyacentes para navegación prev/next — antes de /{project_id}
@router.get("/slug/{slug}/adjacent", response_model=AdjacentResponse)
def get_adjacent_projects(slug: str, db: Session = Depends(get_db)):
    current = (
        db.query(Project)
        .filter(Project.slug == slug, Project.is_published == True)
        .first()
    )
    if current is None:
        raise HTTPException(status_code=404, detail="Project not found")

    prev_project = (
        db.query(Project)
        .filter(Project.is_published == True, Project.order < current.order)
        .order_by(Project.order.desc())
        .first()
    )
    next_project = (
        db.query(Project)
        .filter(Project.is_published == True, Project.order > current.order)
        .order_by(Project.order.asc())
        .first()
    )

    return AdjacentResponse(
        prev=AdjacentProject(title=prev_project.title, slug=prev_project.slug) if prev_project else None,
        next=AdjacentProject(title=next_project.title, slug=next_project.slug) if next_project else None,
    )


# *Obtener proyecto por slug — antes de /{project_id}
@router.get("/slug/{slug}", response_model=ProjectResponse)
def get_project_by_slug(slug: str, db: Session = Depends(get_db)):
    project = db.query(Project).filter(Project.slug == slug).first()
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return project


# *Obtener proyecto por ID
@router.get("/{project_id}", response_model=ProjectResponse)
def get_project(project_id: int, db: Session = Depends(get_db)):
    project = db.query(Project).filter(Project.id == project_id).first()
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return project


# *Crear proyecto
@router.post("/", response_model=ProjectResponse)
def create_project(project: ProjectCreate, db: Session = Depends(get_db)):
    existing = db.query(Project).filter(Project.slug == project.slug).first()
    if existing:
        raise HTTPException(status_code=409, detail="Slug already exists")
    db_project = Project(**project.model_dump())
    db.add(db_project)
    db.commit()
    db.refresh(db_project)
    return db_project


# *Actualizar proyecto
@router.put("/{project_id}", response_model=ProjectResponse)
def update_project(project_id: int, project: ProjectCreate, db: Session = Depends(get_db)):
    db_project = db.query(Project).filter(Project.id == project_id).first()
    if db_project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    for key, value in project.model_dump(exclude_unset=True).items():
        setattr(db_project, key, value)
    db.commit()
    db.refresh(db_project)
    return db_project


# *Eliminar proyecto
@router.delete("/{project_id}")
def delete_project(project_id: int, db: Session = Depends(get_db)):
    db_project = db.query(Project).filter(Project.id == project_id).first()
    if db_project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    db.delete(db_project)
    db.commit()
    return {"message": "Project deleted"}
