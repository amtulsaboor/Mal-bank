# =========================
# Builder Stage
# =========================

FROM python:3.13-slim AS builder

WORKDIR /app


COPY app/requirements.txt .


RUN pip install \
    --no-cache-dir \
    --prefix=/install \
    -r requirements.txt


COPY app/ .



# =========================
# Runtime Stage
# =========================

FROM python:3.13-slim


WORKDIR /app


COPY --from=builder /install /usr/local

COPY --from=builder /app .



# Create non-root user

RUN groupadd --gid 10001 appgroup && \
    useradd --uid 10001 \
    --gid appgroup \
    --no-create-home \
    --shell /usr/sbin/nologin \
    appuser



USER 10001:10001



EXPOSE 8080



HEALTHCHECK \
    --interval=30s \
    --timeout=5s \
    --start-period=10s \
    --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/healthz')"



CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
