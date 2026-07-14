from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import Column,Integer,String,Numeric

class Base(DeclarativeBase):
    pass

class Account(Base):
    __tablename__="accounts"

    id=Column(Integer,primary_key=True)
    name=Column(String)
    balance=Column(Numeric)
    currency=Column(String)
