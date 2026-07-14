# Credential Handling

## Objective

No plaintext credentials are committed to the repository. Application secrets are injected securely at runtime.

---

## Local Development

For local development, credentials are supplied through Docker Compose environment variables or Kubernetes Secrets created outside the repository.

Example:

- PostgreSQL username
- PostgreSQL password
- RabbitMQ username
- RabbitMQ password

The Secret manifest itself is not committed to Git.

---

## Kubernetes

The application consumes credentials through Kubernetes Secrets.

Example:

```yaml
envFrom:
  - secretRef:
      name: bank-api-secret
```

The application never contains hardcoded credentials.

---

## Production (AWS)

In production the Kubernetes Secret would be replaced by:

- AWS Secrets Manager
- External Secrets Operator
- IAM Roles for Service Accounts (IRSA)

Flow:

```
GitHub Actions
      │
      ▼
AWS Secrets Manager
      │
External Secrets Operator
      │
Kubernetes Secret
      │
      ▼
Bank API Pod
```

The pod authenticates using IRSA rather than static AWS access keys.

No AWS credentials are stored inside:

- GitHub
- Docker images
- Kubernetes manifests
- Source code

---

## Database Authentication

The application connects using a least-privilege database role.

Runtime permissions:

- SELECT
- INSERT
- UPDATE

The application cannot:

- DROP tables
- CREATE tables
- ALTER schema
- CREATE users
- Grant privileges
- Become a superuser

---

## Rotation

Secrets are rotated through AWS Secrets Manager.

Pods receive updated secrets through the External Secrets Operator.

Application restart or rolling deployment refreshes credentials.

---

## Repository Security

The repository intentionally excludes:

- passwords
- API keys
- certificates
- private keys
- kubeconfig files
- AWS credentials

These are supplied securely during deployment.

---

## AWS Mapping

| Local | AWS Production |
|--------|----------------|
| Docker Environment Variables | AWS Secrets Manager |
| Kubernetes Secret | External Secrets Operator |
| Service Account | IAM Role for Service Account (IRSA) |
| PostgreSQL Password | Secrets Manager Secret |
| RabbitMQ Password | Secrets Manager Secret |
