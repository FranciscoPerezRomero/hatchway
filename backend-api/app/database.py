from app.core.config import settings
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# *Se crea el motor
engine = create_engine(settings.database_url)

# *Sessions factory
SessionLocal = sessionmaker(autocommit = False, autoflush = False, bind = engine)

# *Clase maestra
Base = declarative_base()

# *Función para injección de dependencias
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()