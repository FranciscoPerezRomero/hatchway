from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional, Literal
from app.schemas.project import ProjectResponse


class QuoteLineItem(BaseModel):
    catalog_item_id: Optional[int] = None
    name: str
    category: str
    price: float
    recurring_price: Optional[float] = None
    recurring_label: Optional[str] = None
    quantity: int = 1


class QuoteBase(BaseModel):
    status: Literal["pendiente", "aceptada", "rechazada"] = "pendiente"

    client_name: Optional[str] = None
    client_business: Optional[str] = None
    client_contact: Optional[str] = None
    problem_description: Optional[str] = None
    categories: list[str] = []
    budget_range: Optional[str] = None

    line_items: list[QuoteLineItem] = []
    total: Optional[float] = None
    recurring_total: Optional[float] = None

    notes: Optional[str] = None
    converted_project_id: Optional[int] = None


class QuoteCreate(QuoteBase):
    pass


class QuoteResponse(QuoteBase):
    id: int
    created_at: datetime
    updated_at: datetime
    model_config = ConfigDict(from_attributes=True)


class QuoteConvertResponse(BaseModel):
    quote: QuoteResponse
    project: ProjectResponse
