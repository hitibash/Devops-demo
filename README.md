# DevOps Demo Project

This is a study-focused DevOps project designed to practice modern CI/CD practices, Docker, security scanning, and secret handling workflows. The setup is optimized for local development and learning purposes.

## 📁 Project Structure

```
├── app/                    # Flask app source code
│   ├── routes/
│   ├── services/
│   ├── templates/
│   ├── utils/
│   └── config.py
├── Dockerfile              # Containerization  
├── tests/
├── docker-compose.yml      # Dev environment setup
├── .env.example            # Environment variable 
├── Jenkinsfile             # CI/CD pipeline
└── sql/                    # MySQL initialization scripts
```

## 🚀 Features

- Dockerized Flask app with MySQL
- Jenkins pipeline with:
  - Docker image build and tagging
  - Trivy vulnerability and secret scanning
  - DockerHub push using Jenkins secrets
- Trivy used to scan for:
  - Vulnerabilities (HIGH/CRITICAL)
  - Leaked secrets in source code
- `.env` file usage for local secrets
- `.env.example` provided for reproducibility

## 🛠 Usage

### Development

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Run using Docker Compose:
   ```bash
   docker-compose up --build
   ```

> 🔐 **Note**: Secrets in `.env` are only used for local/dev purposes. Never commit real credentials.

### CI/CD

- CI pipeline is configured in the `Jenkinsfile`.
- DockerHub credentials are securely handled in Jenkins using `dockerhub-creds`.
- Vulnerability scanning fails the pipeline **only in production**, currently skipped using `|| true` for learning purposes.

## 📦 Image Tags

- `latest` - latest successful build
- `\$BUILD_NUMBER` - Jenkins build number tag

## 🧪 Trivy Security Scans

This project uses [Trivy](https://github.com/aquasecurity/trivy) to detect:

- OS/package vulnerabilities (Debian base)
- Python package vulnerabilities
- Secrets in the source code

Example scan results are logged during the CI process.

## 🔐 Secret Handling (Dev vs Prod)

| Context     | Method                     |
|-------------|----------------------------|
| Dev         | `.env` file (excluded from Git) |
| CI/CD       | Jenkins Secrets + .env.example |
| Kubernetes  | To be implemented: K3s + Kubernetes Secrets or Sealed Secrets |


---

> 🧠 This project is **not** intended for production but serves as a **learning tool** for DevOps workflows.

---
