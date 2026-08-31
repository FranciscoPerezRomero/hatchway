from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional, Literal


# ── Tipos anidados ────────────────────────────────────────

class TechCategory(BaseModel):
    """Una categoría del tech stack con sus tecnologías."""
    category: str
    technologies: list[str]


class Feature(BaseModel):
    """Una feature clave del proyecto."""
    title: str
    description: str


class AdjacentProject(BaseModel):
    """Referencia mínima para navegación prev/next."""
    title: str
    slug: str


class AdjacentResponse(BaseModel):
    prev: Optional[AdjacentProject] = None
    next: Optional[AdjacentProject] = None


# ── Esquema base ──────────────────────────────────────────

class ProjectBase(BaseModel):

    # ── Identificación
    slug: str
    order: int = 0
    project_type: Literal["web_app", "mobile_app", "api", "library", "tool"] = "web_app"
    is_published: bool = False
    is_featured: bool = False

    # ── Hero
    title: str
    tagline: Optional[str] = None
    hero_image_url: Optional[str] = None
    cta_primary_label: Optional[str] = None
    cta_primary_url: Optional[str] = None
    cta_secondary_label: Optional[str] = None
    cta_secondary_url: Optional[str] = None
    repository_url: Optional[str] = None

    # ── Metadata Strip
    role: Optional[str] = None
    year: Optional[int] = None
    status: Optional[Literal["Live", "In Development", "Deprecated", "Open Source"]] = None
    client: Optional[str] = None
    duration: Optional[str] = None
    team_size: Optional[str] = None

    # ── About / Challenge
    challenge_paragraph_1: Optional[str] = None
    challenge_paragraph_2: Optional[str] = None
    key_challenges: list[str] = []

    # ── Tech Stack y Features
    tech_stack: list[TechCategory] = []
    features: list[Feature] = []

    # ── Métricas
    metrics: list[str] = []

    # ── Galería
    main_screenshot_url: Optional[str] = None
    screenshots: list[str] = []

    # ── Card del listado
    card_thumbnail_url: Optional[str] = None
    card_short_description: Optional[str] = None
    tags: list[str] = []

    # ── SEO
    seo_title: Optional[str] = None
    seo_description: Optional[str] = None


# ── Modelos de entrada/salida ─────────────────────────────

class ProjectCreate(ProjectBase):
    pass


class ProjectResponse(ProjectBase):
    id: int
    created_at: datetime
    updated_at: datetime
    model_config = ConfigDict(from_attributes=True)
