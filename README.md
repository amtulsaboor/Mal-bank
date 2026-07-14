# Bank Platform 

A production-style cloud-native banking platform demonstrating containerization, Kubernetes, Infrastructure as Code, CI/CD, observability, messaging, and security best practices.

---

# Architecture

```
                    GitHub
                       │
              GitHub Actions CI/CD
                       │
              Build → Test → Trivy Scan
                       │
                    Docker Image
                       │
                     GHCR/ECR
                       │
                       ▼
                  Kubernetes
        ┌──────────────────────────────┐
        │                              │
        │        Bank API              │
        │                              │
        └──────────────┬───────────────┘
                       │
        ┌──────────────┴───────────────┐
        │                              │
   PostgreSQL                     RabbitMQ
        │                              │
        └──────────────┬───────────────┘
                       │
               Prometheus Metrics
                       │
             OpenTelemetry Collector
                       │
                    Grafana
```

---

# Features

- Multi-stage Docker image
- Non-root container
- Kubernetes Deployment
- Readiness & Liveness probes
- Zero-downtime rolling deployment
- Horizontal Pod Autoscaler
- PodDisruptionBudget
- PostgreSQL
- Least-Privilege Database Access
- RabbitMQ Event Processing
- Idempotent Consumer
- Dead Letter Queue
- GitHub Actions CI/CD
- Trivy Image Scan
- Terraform Infrastructure
- Prometheus Monitoring
- OpenTelemetry Tracing
- Grafana Dashboard

---

# API

## Health

```
GET /healthz
```

Returns application liveness.

---

## Readiness

```
GET /readyz
```

Fails if PostgreSQL is unavailable or the application is shutting down.

---

## Metrics

```
GET /metrics
```

Prometheus metrics endpoint.

---

## Accounts

```
GET /api/accounts/{id}
```

Returns a single account from PostgreSQL.

---

# Local Setup

## Start PostgreSQL

```bash
docker compose up -d
```

---

## Start RabbitMQ

```bash
cd messaging
docker compose up -d
```

---

## Run API

```bash
cd app

uvicorn main:app --reload
```

---

## Run Consumer

```bash
cd messaging

python3 consumer.py
```

---

## Publish Test Event

```bash
python3 producer.py
```

---

# Kubernetes

Deploy application

```bash
kubectl apply -f kubernetes/
```

Check pods

```bash
kubectl get pods
```

---

# Terraform

Validate

```bash
terraform init

terraform validate
```

Generate Plan

```bash
terraform plan
```

No cloud resources are created during this assessment.

---

# CI/CD

Pipeline stages

- Checkout
- Unit Tests
- Build Docker Image
- Trivy Security Scan
- Push Versioned Image
- Manual Approval
- Kubernetes Deployment

Authentication uses GitHub OIDC.

No long-lived AWS credentials are stored.

---

# Security

- Non-root container
- Read-only root filesystem
- Dropped Linux capabilities
- Kubernetes Secret
- Least-Privilege PostgreSQL Role
- Immutable image tags
- Vulnerability scanning using Trivy

---

# Observability

Metrics

- Request Rate
- Error Rate
- Latency

Tracing

- OpenTelemetry Collector

Dashboard

- Grafana

Alerts

- High Error Rate
- High Latency
- Service Down

---

# Messaging

Broker

RabbitMQ

Consumer

Idempotent consumer using a processed_events table.

Duplicate events are ignored using a unique event_id.

Poison messages are moved to a Dead Letter Queue after three retries.

---

# Local to AWS Mapping

| Local | AWS Production |
|--------|----------------|
| Docker | Amazon ECR |
| Kubernetes (kind) | Amazon EKS |
| PostgreSQL | Amazon RDS PostgreSQL |
| RabbitMQ | Amazon MQ / Amazon MSK |
| Docker Secrets | AWS Secrets Manager |
| Kubernetes ServiceAccount | IAM Roles for Service Accounts (IRSA) |
| Prometheus | Amazon Managed Prometheus |
| Grafana | Amazon Managed Grafana |

---

# Project Structure

```
app/
database/
infrastructure/
kubernetes/
messaging/
monitoring/
.github/workflows/
README.md
```
