from sqlalchemy import Column, Integer, String, Text, DateTime, Enum
from sqlalchemy.dialects.postgresql import ARRAY
from datetime import datetime, timezone
from app.database import Base



class Project(Base):
    __tablename__ = "projects"
    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String, nullable=False)
    slug = Column(String, nullable=False, unique=True)
    tagline = Column(String, nullable=True)
    description = Column(Text, nullable=True)
    status = Column(Enum("draft", "published", "archived", name="project_status"), nullable=False)
    tech_stack = Column(ARRAY(String), default=list)
    github_url = Column(String, nullable=True)
    live_url = Column(String, nullable=True)
    demo_url = Column(String, nullable=True)
    thumbnail_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

