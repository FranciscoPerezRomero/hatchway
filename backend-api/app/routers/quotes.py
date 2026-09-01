import re
import unicodedata
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.models.quote import Quote
from app.models.project import Project
from app.schemas.quote import QuoteCreate, QuoteResponse, QuoteConvertResponse

router = APIRouter(prefix="/api/quotes", tags=["quotes"])


def _slugify(value: str) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = value.lower()
    value = re.sub(r"[^a-z0-9\s-]", "", value).strip()
    return re.sub(r"\s+", "-", value)


def _unique_slug(db: Session, base_slug: str) -> str:
    slug = base_slug or "proyecto"
    suffix = 1
    while db.query(Project).filter(Project.slug == slug).first() is not None:
        suffix += 1
        slug = f"{base_slug}-{suffix}"
    return slug


# *Listado con filtro opcional — más recientes primero
@router.get("/", response_model=list[QuoteResponse])
def get_quotes(
    status: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    query = db.query(Quote)
    if status is not None:
        query = query.filter(Quote.status == status)
    return query.order_by(Quote.created_at.desc()).all()


@router.get("/{quote_id}", response_model=QuoteResponse)
def get_quote(quote_id: int, db: Session = Depends(get_db)):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if quote is None:
        raise HTTPException(status_code=404, detail="Quote not found")
    return quote


# *Crear cotización — se guarda de inmediato, sin importar si se acepta después
@router.post("/", response_model=QuoteResponse)
def create_quote(quote: QuoteCreate, db: Session = Depends(get_db)):
    db_quote = Quote(**quote.model_dump())
    db.add(db_quote)
    db.commit()
    db.refresh(db_quote)
    return db_quote


# *Actualizar cotización (estado, ítems, notas, etc.)
@router.put("/{quote_id}", response_model=QuoteResponse)
def update_quote(quote_id: int, quote: QuoteCreate, db: Session = Depends(get_db)):
    db_quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if db_quote is None:
        raise HTTPException(status_code=404, detail="Quote not found")
    for key, value in quote.model_dump(exclude_unset=True).items():
        setattr(db_quote, key, value)
    db.commit()
    db.refresh(db_quote)
    return db_quote


@router.delete("/{quote_id}")
def delete_quote(quote_id: int, db: Session = Depends(get_db)):
    db_quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if db_quote is None:
        raise HTTPException(status_code=404, detail="Quote not found")
    db.delete(db_quote)
    db.commit()
    return {"message": "Quote deleted"}


# *Convertir una cotización aceptada en un proyecto real del portafolio
@router.post("/{quote_id}/convert", response_model=QuoteConvertResponse)
def convert_quote(quote_id: int, db: Session = Depends(get_db)):
    db_quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if db_quote is None:
        raise HTTPException(status_code=404, detail="Quote not found")
    if db_quote.converted_project_id is not None:
        raise HTTPException(status_code=409, detail="Quote already converted")

    title = db_quote.client_business or db_quote.client_name or "Nuevo proyecto"
    slug = _unique_slug(db, _slugify(title))

    db_project = Project(
        slug=slug,
        title=title,
        client=db_quote.client_business or db_quote.client_name,
        is_published=False,
    )
    db.add(db_project)
    db.flush()  # asigna db_project.id sin cerrar la transacción

    db_quote.converted_project_id = db_project.id
    db_quote.status = "aceptada"

    db.commit()
    db.refresh(db_project)
    db.refresh(db_quote)
    return QuoteConvertResponse(quote=db_quote, project=db_project)
