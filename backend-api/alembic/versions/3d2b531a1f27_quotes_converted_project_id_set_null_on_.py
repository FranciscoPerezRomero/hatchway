"""quotes converted_project_id set null on delete

Revision ID: 3d2b531a1f27
Revises: 115fd20017ea
Create Date: 2026-09-01 00:15:49.583630

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '3d2b531a1f27'
down_revision: Union[str, Sequence[str], None] = '115fd20017ea'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.drop_constraint('quotes_converted_project_id_fkey', 'quotes', type_='foreignkey')
    op.create_foreign_key(
        'quotes_converted_project_id_fkey', 'quotes', 'projects',
        ['converted_project_id'], ['id'], ondelete='SET NULL',
    )


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_constraint('quotes_converted_project_id_fkey', 'quotes', type_='foreignkey')
    op.create_foreign_key(
        'quotes_converted_project_id_fkey', 'quotes', 'projects',
        ['converted_project_id'], ['id'],
    )
