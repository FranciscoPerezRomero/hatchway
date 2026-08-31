from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, Enum
from sqlalchemy.dialects.postgresql import ARRAY, JSONB
from datetime import datetime, timezone
from app.database import Base


class Project(Base):
    __tablename__ = "projects"

    # ── Identificación y configuración ────────────────────
    id = Column(Integer, primary_key=True, autoincrement=True)
    slug = Column(String, nullable=False, unique=True)
    order = Column(Integer, nullable=False, default=0)
    project_type = Column(
        Enum("web_app", "mobile_app", "api", "library", "tool", name="project_type_enum"),
        nullable=False,
        default="web_app",
    )
    is_published = Column(Boolean, nullable=False, default=False)
    is_featured = Column(Boolean, nullable=False, default=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    # ── Sección Hero ──────────────────────────────────────
    title = Column(String, nullable=False)
    tagline = Column(String, nullable=True)
    hero_image_url = Column(String, nullable=True)
    cta_primary_label = Column(String, nullable=True)
    cta_primary_url = Column(String, nullable=True)
    cta_secondary_label = Column(String, nullable=True)
    cta_secondary_url = Column(String, nullable=True)
    repository_url = Column(String, nullable=True)

    # ── Metadata Strip ────────────────────────────────────
    role = Column(String, nullable=True)
    year = Column(Integer, nullable=True)
    status = Column(
        Enum("Live", "In Development", "Deprecated", "Open Source", name="project_live_status"),
        nullable=True,
    )
    client = Column(String, nullable=True)
    duration = Column(String, nullable=True)
    team_size = Column(String, nullable=True)

    # ── About / The Challenge ─────────────────────────────
    challenge_paragraph_1 = Column(Text, nullable=True)
    challenge_paragraph_2 = Column(Text, nullable=True)
    key_challenges = Column(ARRAY(String), nullable=True, default=list)

    # ── Tech Stack [{category, technologies}] ─────────────
    tech_stack = Column(JSONB, nullable=False, default=list)

    # ── Key Features [{title, description}] ───────────────
    features = Column(JSONB, nullable=True, default=list)

    # ── Métricas de impacto ───────────────────────────────
    metrics = Column(ARRAY(String), nullable=True, default=list)

    # ── Galería ───────────────────────────────────────────
    main_screenshot_url = Column(String, nullable=True)
    screenshots = Column(ARRAY(String), nullable=True, default=list)

    # ── Card del listado ──────────────────────────────────
    card_thumbnail_url = Column(String, nullable=True)
    card_short_description = Column(String, nullable=True)
    tags = Column(ARRAY(String), nullable=True, default=list)

    # ── SEO ───────────────────────────────────────────────
    seo_title = Column(String, nullable=True)
    seo_description = Column(String, nullable=True)
