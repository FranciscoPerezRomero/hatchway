from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from app.services.cloudinary import upload_image, delete_image
from app.database import get_db
from app.models.project import Project
from sqlalchemy.orm import Session

router = APIRouter(tags=["images"])


@router.post("/api/projects/{project_id}/images")
async def upload_project_image(project_id: int, file: UploadFile = File(...), db: Session = Depends(get_db)):
    project = db.query(Project).filter(Project.id == project_id).first()
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    contents = await file.read()
    url = upload_image(contents)
    project.thumbnail_url = url
    db.commit()
    db.refresh(project)
    return {"thumbnail_url":url}

@router.delete("/api/images/{public_id}")
async def remove_image(public_id: str):
    delete_image(public_id)
    return {"message":"Image deleted"}