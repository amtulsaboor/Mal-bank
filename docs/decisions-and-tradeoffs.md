# Decisions and Trade-offs

## Objective

The goal of this assessment was to build the platform surrounding a regulated banking service rather than the business application itself. The focus was therefore on reliability, security, deployment safety, observability and operational simplicity.

---

# Scope

Given the time limit (3–4 hours), priority was given to implementing one complete path end-to-end rather than partially implementing many features.

Completed:

- Containerized application
- Kubernetes deployment
- PostgreSQL integration
- RabbitMQ messaging
- Idempotent consumer
- CI/CD pipeline
- Terraform infrastructure
- Prometheus monitoring
- OpenTelemetry configuration
- Grafana dashboard
- Security hardening

Items intentionally simplified:

- Single service
- Single database
- Single RabbitMQ broker
- Local Kubernetes cluster instead of Amazon EKS
- Terraform validated but not applied

These simplifications reduce complexity while preserving the production architecture.

---

# Container

A multi-stage Docker build was chosen to minimise image size and reduce the attack surface.

The final image:

- runs as a non-root user
- uses a read-only root filesystem
- drops unnecessary Linux capabilities
- exposes only the required port
- includes a health check

This follows container hardening best practices.

---

# Kubernetes

RollingUpdate deployments were selected to achieve zero-downtime deployments.

The rollout relies on:

- readiness probes
- liveness probes
- preStop hook
- terminationGracePeriodSeconds

When Kubernetes begins terminating a pod, `/readyz` fails immediately so the pod is removed from Service endpoints before shutdown, allowing in-flight requests to complete.

A PodDisruptionBudget ensures voluntary disruptions never remove all replicas simultaneously.

---

# Autoscaling

Horizontal Pod Autoscaler was configured using CPU utilisation.

For a production banking platform, request rate or queue depth would generally be a better scaling signal than CPU because the service is primarily I/O bound.

CPU was chosen here because it is available without additional metrics infrastructure.

---

# Database

PostgreSQL was selected because it is mature, reliable and commonly used in regulated financial systems.

The application connects using a dedicated least-privilege role.

Runtime permissions are limited to:

- SELECT
- INSERT
- UPDATE

The application deliberately cannot:

- DROP tables
- CREATE tables
- ALTER schema
- CREATE users
- grant privileges

Database schema changes should only occur through controlled migration pipelines.

---

# Secrets

No credentials are committed to source control.

Local development uses Docker or Kubernetes Secrets.

Production would use:

- AWS Secrets Manager
- External Secrets Operator
- IAM Roles for Service Accounts (IRSA)

This removes long-lived AWS credentials from both GitHub Actions and Kubernetes.

---

# Messaging

RabbitMQ was selected because the workload requires reliable asynchronous processing rather than high-throughput event streaming.

The consumer is designed to be idempotent.

Each event contains a unique event identifier.

Processed events are recorded in the `processed_events` table.

Duplicate deliveries therefore have no effect.

Messages that fail processing repeatedly are moved to a Dead Letter Queue after three attempts to prevent blocking the queue.

---

# CI/CD

GitHub Actions provides:

- unit tests
- Docker image build
- Trivy vulnerability scanning
- immutable versioned image tags
- deployment
- manual approval before production

OIDC federation replaces long-lived AWS access keys.

Rollback is performed using the previous immutable image tag with Helm rollback.

---

# Infrastructure

Terraform was used to define infrastructure as code.

Resources include:

- Amazon EKS
- Amazon ECR
- Amazon RDS PostgreSQL
- IAM Roles for Service Accounts
- AWS Secrets Manager

Terraform was validated and planned but intentionally not applied.

---

# Observability

The service exposes RED metrics:

- Request Rate
- Error Rate
- Request Duration

Tracing is configured using OpenTelemetry.

Prometheus collects metrics.

Grafana provides operational dashboards.

Alerts are configured for:

- service unavailable
- elevated latency
- high HTTP 5xx error rate

---

# PII Handling

Personally identifiable information is intentionally excluded from telemetry.

Application logs avoid recording:

- customer names
- account balances
- passwords
- authentication tokens

Request identifiers are retained for correlation.

Although sensitive fields are removed before export, application developers must still avoid logging customer data inside business logic.

---

# Backup Strategy

Production deployments would use automated Amazon RDS snapshots with point-in-time recovery enabled.

Target objectives:

- Recovery Point Objective (RPO): 15 minutes
- Recovery Time Objective (RTO): less than 1 hour

Backups should be tested regularly through restore exercises rather than assumed to work.

---

# Reliability

The platform prioritises availability during deployments.

Key reliability mechanisms include:

- readiness probes
- rolling deployments
- graceful shutdown
- PodDisruptionBudget
- health checks
- idempotent messaging
- retry logic
- dead-letter queue

---

# Future Improvements

Given additional time the platform would be extended with:

- Blue/Green deployments
- Canary releases using Argo Rollouts
- PgBouncer connection pooling
- Distributed tracing with Jaeger or AWS X-Ray
- GitOps using ArgoCD
- Chaos engineering
- Multi-AZ PostgreSQL
- Multi-node RabbitMQ cluster
- Service mesh with Istio
- Policy enforcement using Kyverno or OPA Gatekeeper

---

# Conclusion

The implementation focuses on demonstrating production engineering practices rather than application complexity.

The platform emphasises secure software delivery, least-privilege access, reliable deployments, observability and operational resilience while remaining intentionally small enough to complete within the assessment time.
