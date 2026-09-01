from pydantic import BaseModel, ConfigDict
from typing import Optional


class PriceCatalogItemBase(BaseModel):
    category: str
    name: str
    description: Optional[str] = None

    price_min: float
    price_max: Optional[float] = None

    recurring_price_min: Optional[float] = None
    recurring_price_max: Optional[float] = None
    recurring_label: Optional[str] = None

    is_recommended: bool = False
    is_active: bool = True
    order: int = 0


class PriceCatalogItemCreate(PriceCatalogItemBase):
    pass


class PriceCatalogItemResponse(PriceCatalogItemBase):
    id: int
    model_config = ConfigDict(from_attributes=True)
