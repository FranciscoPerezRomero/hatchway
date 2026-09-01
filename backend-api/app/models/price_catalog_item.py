from sqlalchemy import Column, Integer, String, Boolean, Numeric
from app.database import Base


class PriceCatalogItem(Base):
    __tablename__ = "price_catalog_items"

    id = Column(Integer, primary_key=True, autoincrement=True)
    category = Column(String, nullable=False)
    name = Column(String, nullable=False)
    description = Column(String, nullable=True)

    # *Precio de pago único — price_max nulo = precio fijo
    price_min = Column(Numeric(10, 2), nullable=False)
    price_max = Column(Numeric(10, 2), nullable=True)

    # *Precio recurrente opcional (ej. mensualidad de un plan)
    recurring_price_min = Column(Numeric(10, 2), nullable=True)
    recurring_price_max = Column(Numeric(10, 2), nullable=True)
    recurring_label = Column(String, nullable=True)

    is_recommended = Column(Boolean, nullable=False, default=False)
    is_active = Column(Boolean, nullable=False, default=True)
    order = Column(Integer, nullable=False, default=0)
