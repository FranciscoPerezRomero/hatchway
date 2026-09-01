from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from app.database import get_db
from app.models.price_catalog_item import PriceCatalogItem
from app.schemas.price_catalog_item import PriceCatalogItemCreate, PriceCatalogItemResponse

router = APIRouter(prefix="/api/price-catalog", tags=["price-catalog"])


# *Listado — ordenado por categoría y luego por 'order'
@router.get("/", response_model=list[PriceCatalogItemResponse])
def get_price_catalog(
    is_active: Optional[bool] = Query(None),
    db: Session = Depends(get_db),
):
    query = db.query(PriceCatalogItem)
    if is_active is not None:
        query = query.filter(PriceCatalogItem.is_active == is_active)
    return query.order_by(PriceCatalogItem.category.asc(), PriceCatalogItem.order.asc()).all()


# *Crear ítem
@router.post("/", response_model=PriceCatalogItemResponse)
def create_price_catalog_item(item: PriceCatalogItemCreate, db: Session = Depends(get_db)):
    db_item = PriceCatalogItem(**item.model_dump())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item


# *Actualizar ítem
@router.put("/{item_id}", response_model=PriceCatalogItemResponse)
def update_price_catalog_item(item_id: int, item: PriceCatalogItemCreate, db: Session = Depends(get_db)):
    db_item = db.query(PriceCatalogItem).filter(PriceCatalogItem.id == item_id).first()
    if db_item is None:
        raise HTTPException(status_code=404, detail="Price catalog item not found")
    for key, value in item.model_dump(exclude_unset=True).items():
        setattr(db_item, key, value)
    db.commit()
    db.refresh(db_item)
    return db_item


# *Eliminar ítem
@router.delete("/{item_id}")
def delete_price_catalog_item(item_id: int, db: Session = Depends(get_db)):
    db_item = db.query(PriceCatalogItem).filter(PriceCatalogItem.id == item_id).first()
    if db_item is None:
        raise HTTPException(status_code=404, detail="Price catalog item not found")
    db.delete(db_item)
    db.commit()
    return {"message": "Price catalog item deleted"}
