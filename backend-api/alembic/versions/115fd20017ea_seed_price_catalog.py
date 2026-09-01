"""seed price catalog

Revision ID: 115fd20017ea
Revises: 155aad4a96e6
Create Date: 2026-09-01

Siembra el catálogo de precios con las tarifas reales compartidas por el
usuario (Páginas web, Mantenimiento, Sistema POS, Sistema Restaurantes,
Extras, Automatización, Dominio) para no tener que capturarlas a mano.
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = '115fd20017ea'
down_revision: Union[str, Sequence[str], None] = '155aad4a96e6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

price_catalog_items = sa.table(
    'price_catalog_items',
    sa.column('category', sa.String),
    sa.column('name', sa.String),
    sa.column('description', sa.String),
    sa.column('price_min', sa.Numeric),
    sa.column('price_max', sa.Numeric),
    sa.column('recurring_price_min', sa.Numeric),
    sa.column('recurring_price_max', sa.Numeric),
    sa.column('recurring_label', sa.String),
    sa.column('is_recommended', sa.Boolean),
    sa.column('is_active', sa.Boolean),
    sa.column('order', sa.Integer),
)


def _item(category, name, price_min, price_max=None, description=None,
          recurring_price_min=None, recurring_price_max=None, recurring_label=None,
          is_recommended=False, order=0):
    return {
        'category': category,
        'name': name,
        'description': description,
        'price_min': price_min,
        'price_max': price_max,
        'recurring_price_min': recurring_price_min,
        'recurring_price_max': recurring_price_max,
        'recurring_label': recurring_label,
        'is_recommended': is_recommended,
        'is_active': True,
        'order': order,
    }


ROWS = [
    # ── Páginas web ─────────────────────────────────────────
    _item('Páginas web', 'Landing page', 3500, 5000, '1 página · SPA · WhatsApp · Maps', order=0),
    _item('Páginas web', 'Sitio vitrina', 6000, 9000, '4-6 páginas · SEO básico · galería', order=1),
    _item('Páginas web', 'Sitio con funcionalidad', 10000, 18000, 'Reservaciones · menú · blog · formularios', order=2),
    _item('Páginas web', 'E-commerce', 15000, 25000, 'Catálogo · carrito · Stripe/MercadoPago', order=3),

    # ── Mantenimiento (solo recurrente) ─────────────────────
    _item('Mantenimiento', 'Hosting básico', 0, description='Servidor + SSL',
          recurring_price_min=250, recurring_price_max=350, recurring_label='/mes', order=0),
    _item('Mantenimiento', 'Hosting + soporte', 0, description='+ 1 actualización/mes',
          recurring_price_min=450, recurring_price_max=600, recurring_label='/mes', order=1),
    _item('Mantenimiento', 'Mantenimiento', 0, description='+ 10 cambios/mes',
          recurring_price_min=700, recurring_price_max=1000, recurring_label='/mes', order=2),

    # ── Sistema POS — Tiendas y Verdulerías ─────────────────
    _item('Sistema POS', 'Básico', 3000, 4000, 'Tu caja inteligente · 1 PdV',
          recurring_price_min=500, recurring_label='/mes', order=0),
    _item('Sistema POS', 'Profesional', 5000, 8000, 'Tu negocio bajo control · Hasta 3 PdV',
          recurring_price_min=875, recurring_label='/mes', is_recommended=True, order=1),
    _item('Sistema POS', 'Premium', 10000, 15000, 'Tu negocio en la nube · PdV ilimitados',
          recurring_price_min=1800, recurring_label='/mes', order=2),

    # ── Sistema de restaurantes ──────────────────────────────
    _item('Sistema Restaurantes', 'Básico', 5000, 7000, 'Tu restaurante digitalizado · 1 PdV',
          recurring_price_min=750, recurring_label='/mes', order=0),
    _item('Sistema Restaurantes', 'Profesional', 9000, 12000, 'Tu restaurante bajo control · Hasta 5 PdV',
          recurring_price_min=1250, recurring_label='/mes', is_recommended=True, order=1),
    _item('Sistema Restaurantes', 'Premium', 15000, 18000, 'Tu restaurante en la nube · PdV ilimitados',
          recurring_price_min=2200, recurring_label='/mes', order=2),

    # ── Extras — Páginas web ─────────────────────────────────
    _item('Extras Páginas Web', 'Botón WhatsApp (link directo)', 300, order=0),
    _item('Extras Páginas Web', 'Formulario de contacto', 500, order=1),
    _item('Extras Páginas Web', 'Google Maps integrado', 300, order=2),
    _item('Extras Páginas Web', 'Galería con visor', 800, order=3),
    _item('Extras Páginas Web', 'Formulario de reservaciones', 1500, order=4),
    _item('Extras Páginas Web', 'Sección de menú', 1200, order=5),
    _item('Extras Páginas Web', 'Catálogo de productos', 1200, order=6),
    _item('Extras Páginas Web', 'Blog / noticias', 2000, order=7),
    _item('Extras Páginas Web', 'SEO básico inicial', 1500, 3000, order=8),
    _item('Extras Páginas Web', 'Google My Business setup', 500, 800, order=9),

    # ── Extras — Sistemas (POS y restaurante) ────────────────
    _item('Extras Sistemas', 'Punto de venta adicional', 1500,
          recurring_price_min=200, recurring_label='/mes', order=0),
    _item('Extras Sistemas', 'Sucursal adicional', 3000,
          recurring_price_min=600, recurring_label='/mes', order=1),
    _item('Extras Sistemas', 'Migración Básico → Profesional', 3000, order=2),
    _item('Extras Sistemas', 'Migración Profesional → Premium', 6000, order=3),
    _item('Extras Sistemas', 'Lector de barras (instalación)', 500, order=4),
    _item('Extras Sistemas', 'Impresora de tickets (config.)', 800, order=5),
    _item('Extras Sistemas', 'Soporte presencial', 500, description='Costo por visita', order=6),

    # ── Automatización ────────────────────────────────────────
    _item('Automatización', 'Bot WhatsApp básico', 4000,
          recurring_price_min=350, recurring_label='/mes', order=0),
    _item('Automatización', 'Bot WhatsApp con IA', 8000,
          recurring_price_min=600, recurring_label='/mes', order=1),

    # ── Dominio (solo recurrente, gasto siempre separado) ────
    _item('Dominio', '.com', 0, recurring_price_min=150, recurring_price_max=250, recurring_label='/año', order=0),
    _item('Dominio', '.com.mx', 0, recurring_price_min=300, recurring_price_max=500, recurring_label='/año', order=1),
    _item('Dominio', '.mx', 0, recurring_price_min=400, recurring_price_max=600, recurring_label='/año', order=2),
]


def upgrade() -> None:
    op.bulk_insert(price_catalog_items, ROWS)


def downgrade() -> None:
    op.execute("DELETE FROM price_catalog_items")
