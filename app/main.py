from fastapi import FastAPI, HTTPException
from sqlalchemy import text
from database import engine
from prometheus_fastapi_instrumentator import Instrumentator
import signal

app = FastAPI()

ready = True

@app.get("/healthz")
def health():
    return {"status":"healthy"}

@app.get("/readyz")
def readiness():
    if ready:
        return {"status":"ready"}
    raise HTTPException(status_code=503,detail="Not Ready")

@app.get("/api/accounts/{id}")
def account(id:int):

    with engine.connect() as conn:

        result=conn.execute(
            text(
                "select id,name,balance,currency from accounts where id=:id"
            ),
            {"id":id}
        ).fetchone()

        if result is None:
            raise HTTPException(404,"Account Not Found")

        return {
            "id":result.id,
            "name":result.name,
            "balance":float(result.balance),
            "currency":result.currency
        }

def shutdown(*args):
    global ready
    ready=False

signal.signal(signal.SIGTERM,shutdown)

Instrumentator().instrument(app).expose(app)
