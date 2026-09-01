from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime
from sqlalchemy.dialects.postgresql import ARRAY
from datetime import datetime, timezone
from app.database import Base


class Post(Base):
    __tablename__ = "posts"

    # ── Identificación ─────────────────────────────────────
    id = Column(Integer, primary_key=True, autoincrement=True)
    slug = Column(String, nullable=False, unique=True)
    title = Column(String, nullable=False)
    is_published = Column(Boolean, nullable=False, default=False)
    published_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    # ── Contenido ──────────────────────────────────────────
    excerpt = Column(Text, nullable=True)
    content = Column(Text, nullable=True)
    cover_image_url = Column(String, nullable=True)
    tags = Column(ARRAY(String), nullable=True, default=list)

    # ── SEO ────────────────────────────────────────────────
    seo_title = Column(String, nullable=True)
    seo_description = Column(String, nullable=True)
