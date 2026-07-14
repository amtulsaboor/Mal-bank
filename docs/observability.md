# Observability

## Monitoring Strategy

The service follows the RED methodology for application monitoring.

Metrics collected:

- Request Rate
- Error Rate
- Request Duration

The `/metrics` endpoint exposes Prometheus-compatible metrics.

Prometheus scrapes the application every 15 seconds.

---

## Tracing

OpenTelemetry is configured to collect distributed traces.

The request path is:

```
Client
   │
   ▼
Bank API
   │
   ▼
PostgreSQL
```

Each request includes a Trace ID for end-to-end correlation.

In production, traces would be exported to:

- AWS X-Ray
- Grafana Tempo
- Jaeger

---

## Dashboard

Grafana dashboard includes:

- Requests per second
- HTTP 5xx error rate
- 95th percentile latency

These metrics provide a quick operational overview of service health.

---

## Alerting

The following alerts are configured:

### High Error Rate

Condition:

- HTTP 5xx error rate > 5%
- Sustained for 5 minutes

Severity:

Critical

Action:

Page the on-call engineer.

---

### Service Down

Condition:

Application cannot be scraped by Prometheus.

Severity:

Critical

Action:

Immediate investigation.

---

### High Latency

Condition:

95th percentile latency exceeds one second.

Severity:

Warning

Action:

Investigate database performance, application logs, and infrastructure health.

---

## Log Management

Application logs include:

- Request ID
- Trace ID
- Timestamp
- HTTP Method
- HTTP Status
- Response Time

Logs intentionally avoid sensitive customer information.

---

## PII Scrubbing

Before telemetry leaves the application the following fields are excluded:

- Customer names
- Email addresses
- Phone numbers
- Passwords
- Authentication tokens
- Account balances
- Card numbers
- CVV
- Government identifiers

Only technical metadata is exported.

Example:

```
Request ID
Trace ID
HTTP Method
Status Code
Latency
```

---

## Known Limitations

Automatic scrubbing cannot prevent developers from manually logging sensitive business data.

Code reviews and secure logging guidelines are required to ensure customer information is never written to logs.

---

## Production Mapping

| Local | Production AWS |
|--------|----------------|
| Prometheus | Amazon Managed Prometheus |
| Grafana | Amazon Managed Grafana |
| OpenTelemetry Collector | AWS Distro for OpenTelemetry (ADOT) |
| Local Logs | Amazon CloudWatch Logs |
| Local Traces | AWS X-Ray |
