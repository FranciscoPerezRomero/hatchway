from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional


class PostBase(BaseModel):
    slug: str
    title: str
    is_published: bool = False
    published_at: Optional[datetime] = None

    excerpt: Optional[str] = None
    content: Optional[str] = None
    cover_image_url: Optional[str] = None
    tags: list[str] = []

    seo_title: Optional[str] = None
    seo_description: Optional[str] = None


class PostCreate(PostBase):
    pass


class PostResponse(PostBase):
    id: int
    created_at: datetime
    updated_at: datetime
    model_config = ConfigDict(from_attributes=True)
