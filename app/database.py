from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://bank_app:bank_password@postgres:5432/bankdb"

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(bind=engine)
