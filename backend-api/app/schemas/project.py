from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional

# *Información general
class ProjectBase(BaseModel):
    title : str
    slug: str
    tagline: Optional[str] = None
    description: Optional[str] = None
    status: str 
    tech_stack: list 
    github_url: Optional[str] = None
    live_url: Optional[str] = None
    demo_url: Optional[str] = None 
    thumbnail_url: Optional[str] = None

# *Modelo para envió de datos
class ProjectCreate(ProjectBase):
    pass

# *Modelo para respuesta del servidor
class ProjectResponse(ProjectBase):
    id: int
    created_at: datetime
    updated_at: datetime
    model_config = ConfigDict(from_attributes=True)

    