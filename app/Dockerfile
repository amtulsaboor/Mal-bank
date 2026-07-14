FROM python:3.13-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

FROM python:3.13-slim

WORKDIR /app

COPY --from=builder /usr/local /usr/local

COPY --from=builder /app .

RUN useradd -u 10001 appuser

USER 10001

EXPOSE 8080

HEALTHCHECK CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/healthz')"

CMD ["uvicorn","main:app","--host","0.0.0.0","--port","8080"]
