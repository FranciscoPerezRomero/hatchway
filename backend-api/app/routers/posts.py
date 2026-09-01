from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.models.post import Post
from app.schemas.post import PostCreate, PostResponse

router = APIRouter(prefix="/api/posts", tags=["posts"])


# *Listado con filtro opcional — ordenado por published_at desc, más nuevos primero
@router.get("/", response_model=list[PostResponse])
def get_posts(
    is_published: Optional[bool] = Query(None),
    db: Session = Depends(get_db),
):
    query = db.query(Post)
    if is_published is not None:
        query = query.filter(Post.is_published == is_published)
    return query.order_by(Post.created_at.desc()).all()


# *Obtener post por slug — antes de /{post_id}
@router.get("/slug/{slug}", response_model=PostResponse)
def get_post_by_slug(slug: str, db: Session = Depends(get_db)):
    post = db.query(Post).filter(Post.slug == slug).first()
    if post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return post


# *Obtener post por ID
@router.get("/{post_id}", response_model=PostResponse)
def get_post(post_id: int, db: Session = Depends(get_db)):
    post = db.query(Post).filter(Post.id == post_id).first()
    if post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return post


# *Crear post
@router.post("/", response_model=PostResponse)
def create_post(post: PostCreate, db: Session = Depends(get_db)):
    existing = db.query(Post).filter(Post.slug == post.slug).first()
    if existing:
        raise HTTPException(status_code=409, detail="Slug already exists")
    db_post = Post(**post.model_dump())
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return db_post


# *Actualizar post
@router.put("/{post_id}", response_model=PostResponse)
def update_post(post_id: int, post: PostCreate, db: Session = Depends(get_db)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    for key, value in post.model_dump(exclude_unset=True).items():
        setattr(db_post, key, value)
    db.commit()
    db.refresh(db_post)
    return db_post


# *Eliminar post
@router.delete("/{post_id}")
def delete_post(post_id: int, db: Session = Depends(get_db)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if db_post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    db.delete(db_post)
    db.commit()
    return {"message": "Post deleted"}
