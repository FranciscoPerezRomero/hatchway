"""redesign projects schema

Revision ID: b2f4e8c1d5a7
Revises: 828e7521f6e2
Create Date: 2026-06-12

Rediseño completo del esquema de proyectos para soportar la página de
detalle del portafolio (hero, metadata strip, challenge, tech stack
categorizado, features, galería, navegación prev/next).
"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision: str = 'b2f4e8c1d5a7'
down_revision: Union[str, Sequence[str], None] = '828e7521f6e2'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Elimina la tabla anterior y el enum viejo
    op.drop_table('projects')
    op.execute("DROP TYPE IF EXISTS project_status")

    # Crea la nueva tabla — sa.Enum crea los tipos automáticamente
    op.create_table(
        'projects',

        # ── Identificación y configuración
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('slug', sa.String(), nullable=False),
        sa.Column('order', sa.Integer(), nullable=False, server_default='0'),
        sa.Column(
            'project_type',
            sa.Enum('web_app', 'mobile_app', 'api', 'library', 'tool', name='project_type_enum'),
            nullable=False,
            server_default='web_app',
        ),
        sa.Column('is_published', sa.Boolean(), nullable=False, server_default='false'),
        sa.Column('is_featured', sa.Boolean(), nullable=False, server_default='false'),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),

        # ── Hero
        sa.Column('title', sa.String(), nullable=False),
        sa.Column('tagline', sa.String(), nullable=True),
        sa.Column('hero_image_url', sa.String(), nullable=True),
        sa.Column('cta_primary_label', sa.String(), nullable=True),
        sa.Column('cta_primary_url', sa.String(), nullable=True),
        sa.Column('cta_secondary_label', sa.String(), nullable=True),
        sa.Column('cta_secondary_url', sa.String(), nullable=True),
        sa.Column('repository_url', sa.String(), nullable=True),

        # ── Metadata Strip
        sa.Column('role', sa.String(), nullable=True),
        sa.Column('year', sa.Integer(), nullable=True),
        sa.Column(
            'status',
            sa.Enum('Live', 'In Development', 'Deprecated', 'Open Source', name='project_live_status'),
            nullable=True,
        ),
        sa.Column('client', sa.String(), nullable=True),
        sa.Column('duration', sa.String(), nullable=True),
        sa.Column('team_size', sa.String(), nullable=True),

        # ── About / Challenge
        sa.Column('challenge_paragraph_1', sa.Text(), nullable=True),
        sa.Column('challenge_paragraph_2', sa.Text(), nullable=True),
        sa.Column('key_challenges', postgresql.ARRAY(sa.String()), nullable=True),

        # ── Tech Stack y Features (JSONB para soportar objetos anidados)
        sa.Column('tech_stack', postgresql.JSONB(), nullable=False, server_default='[]'),
        sa.Column('features', postgresql.JSONB(), nullable=True, server_default='[]'),

        # ── Métricas
        sa.Column('metrics', postgresql.ARRAY(sa.String()), nullable=True),

        # ── Galería
        sa.Column('main_screenshot_url', sa.String(), nullable=True),
        sa.Column('screenshots', postgresql.ARRAY(sa.String()), nullable=True),

        # ── Card del listado
        sa.Column('card_thumbnail_url', sa.String(), nullable=True),
        sa.Column('card_short_description', sa.String(), nullable=True),
        sa.Column('tags', postgresql.ARRAY(sa.String()), nullable=True),

        # ── SEO
        sa.Column('seo_title', sa.String(), nullable=True),
        sa.Column('seo_description', sa.String(), nullable=True),

        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('slug'),
    )


def downgrade() -> None:
    op.drop_table('projects')
    op.execute("DROP TYPE IF EXISTS project_live_status")
    op.execute("DROP TYPE IF EXISTS project_type_enum")

    # Restaura el esquema original
    op.create_table(
        'projects',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('title', sa.String(), nullable=False),
        sa.Column('slug', sa.String(), nullable=False),
        sa.Column('tagline', sa.String(), nullable=True),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column(
            'status',
            sa.Enum('draft', 'published', 'archived', name='project_status'),
            nullable=False,
        ),
        sa.Column('tech_stack', postgresql.ARRAY(sa.String()), nullable=True),
        sa.Column('github_url', sa.String(), nullable=True),
        sa.Column('live_url', sa.String(), nullable=True),
        sa.Column('demo_url', sa.String(), nullable=True),
        sa.Column('thumbnail_url', sa.String(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('slug'),
    )
