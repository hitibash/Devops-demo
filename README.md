# DevOps Demo Project

## Table of Contents
- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Architecture Summary](#architecture-summary)
- [CI/CD Pipeline](#cicd-pipeline)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Monitoring](#monitoring)
- [Secrets & Configuration](#secrets--configuration)
- [Testing](#testing)
- [Local Development](#local-development)
- [Simulated Environments](#simulated-environments)

---

## Project Overview

This project demonstrates a complete DevOps pipeline and infrastructure using modern tools and best practices. It includes a containerized Flask application with a MySQL backend, CI/CD pipelines using Jenkins, Kubernetes orchestration via k3s, and a monitoring stack using Prometheus and Grafana.

## Technologies Used

- **Flask** – Python web framework for the app
- **MySQL** – Relational database
- **Docker** – Containerization
- **Jenkins** – Continuous Integration and Deployment
- **Trivy** – Security vulnerability scanning
- **Kubernetes (k3s)** – Lightweight K8s distribution for orchestration
- **Helm** – For installing Prometheus and Grafana
- **Prometheus + Grafana** – Monitoring and dashboards

---

## Architecture Summary

- Flask App is containerized and deployed via Jenkins to a k3s cluster.
- MySQL is deployed with persistent volume and initialized via a Kubernetes Job.
- Secrets are managed using Kubernetes Secrets (Base64-encoded).
- CI pipeline includes:
  - Linting and testing
  - Image build and Trivy scan
  - Push to DockerHub
  - CD to k3s using `kubectl apply`
- Monitoring with Prometheus and Grafana via Helm in `monitoring/` namespace.

---


## CI/CD Pipeline

CI/CD is managed through a Jenkins pipeline that performs the following steps:
1. **Workspace CleanUp** using cleanWs()
2. **Clone the Repository**
3. **Build Docker Image** 
4. **Run Tests** (`run-tests.py`)
5. **Scan Image** using Trivy
6. **Tag Docker Image** using build number as versioning
7. **Push to DockerHub**
8. **Deploy to Kubernetes** via `kubectl` and template substitution

---

## Kubernetes Deployment

The application is deployed on a local **k3s** cluster. Key components:

- `deployment.template.yaml`: Template for Flask app Deployment
- `db_deployment.yaml`: MySQL Deployment
- `db_pvc.yaml`: Persistent volume for database storage
- `db_init_job.yaml`: Initializes the database schema
- `secrets.yaml`: Kubernetes Secrets (base64-encoded)

For full details, see [`k3s/README.md`](./k3s/README.md)

---

## Monitoring

Monitoring is handled via Helm charts in the `monitoring/` folder:

- Prometheus collects metrics
- Grafana displays dashboards (e.g. [ID 1860 – Kubernetes Cluster Monitoring (via Prometheus)](https://grafana.com/grafana/dashboards/1860))
- Grafana is exposed via NodePort for browser access

More info in [`monitoring/README.md`](./monitoring/README.md)

**Note:** For further visibility, application-level metrics (e.g. request rates) can be added by integrating Prometheus client libraries. This was skipped to avoid code modifications.

---

## Secrets & Configuration

- Environment variables are used extensively (following [12-Factor App](https://12factor.net/config) principles).
- Secrets and DB config are injected via Kubernetes Secrets.
- For dev environments, `.env` or default values are used.

 See [`app/README.md`](./app/README.md)

---

## Testing

Database readiness and integration is tested using `tests/run-tests.py`.

- The script waits for MySQL to become available
- Connects and runs simple queries to verify schema and data

---

## Local Development

### Setup

```bash
git clone https://github.com/hitibash/Devops-demo.git
cd Devops-demo
cp .env.example .env

```

Depending on your Docker version:

- Use `docker-compose`:
  ```bash
  docker-compose up --build
  ```

- Or use `docker compose`:
  ```bash
  docker compose up --build
  ```

To tear down the setup:
```bash
docker-compose down -v  # or docker compose down -v
```
git status