from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Enum, Numeric
from sqlalchemy.dialects.postgresql import ARRAY, JSONB
from datetime import datetime, timezone
from app.database import Base


class Quote(Base):
    __tablename__ = "quotes"

    id = Column(Integer, primary_key=True, autoincrement=True)
    status = Column(
        Enum("pendiente", "aceptada", "rechazada", name="quote_status_enum"),
        nullable=False,
        default="pendiente",
    )
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    # ── Cliente / intake ──────────────────────────────────
    client_name = Column(String, nullable=True)
    client_business = Column(String, nullable=True)
    client_contact = Column(String, nullable=True)
    problem_description = Column(Text, nullable=True)
    categories = Column(ARRAY(String), nullable=True, default=list)
    budget_range = Column(String, nullable=True)

    # ── Ítems y totales ────────────────────────────────────
    # Snapshot congelado por ítem — no referencia viva al catálogo, así un
    # cambio de precio posterior no altera cotizaciones ya creadas.
    line_items = Column(JSONB, nullable=False, default=list)
    total = Column(Numeric(10, 2), nullable=True)
    recurring_total = Column(Numeric(10, 2), nullable=True)

    notes = Column(Text, nullable=True)
    converted_project_id = Column(Integer, ForeignKey("projects.id", ondelete="SET NULL"), nullable=True)
