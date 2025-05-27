# Secrets and Configuration Management

This project follows best practices for managing sensitive configuration and secrets, with a clear separation between development and production environments.

## 🔐 Secrets Handling

### Development Environment

- Secrets are typically stored in a local `.env` file.
- This file contains variables like:
  ```env
  DB_HOST=localhost
  DB_PORT=3306
  DB_NAME=todo_app
  DB_USER=app_user
  DB_PASSWORD=123456
  ```
- **Note**: The `.env` file is listed in `.gitignore` and **never committed to version control**.
- These values are loaded into the Flask app using `python-dotenv` or similar tooling.
- Dev environment credentials are dummy and used only for testing locally.

### Production / Kubernetes Environment

- Secrets are stored securely using **Kubernetes Secrets**.
- A `secrets.yaml` file defines environment-specific values (base64-encoded) for production deployment:
  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: mysql-secret
  type: Opaque
  data:
    MYSQL_USER: YXBwX3VzZXI=
    MYSQL_PASSWORD: MTIzNDU2
    MYSQL_DATABASE: dG9kb19hcHA=
    MYSQL_HOST: bXlzcWw=
  ```
- These secrets are **mounted into pods as environment variables** using `env.valueFrom.secretKeyRef` in both the app deployment and the MySQL init job.
- This approach prevents sensitive data from being exposed in logs or stored in container images.

## ⚙️ Configuration Strategy

- **Application configuration** (like database host, port, etc.) is injected through environment variables, following [12-Factor App](https://12factor.net/config) principles.
- The Flask app reads these values using `os.getenv(...)`, which allows for seamless switching between environments.

## 🧪 CI/CD Integration

- During CI/CD via Jenkins:
  - Secrets required for the build or tests are provided using Jenkins **credentials** or injected from securely stored secret files.
  - Sensitive values are not echoed in logs.
  - A placeholder `.env.test` or secret YAML is injected during the testing stage if required.

## ✅ Summary

| Feature        | Development                          | Production / Kubernetes          |
|----------------|--------------------------------------|----------------------------------|
| Secrets Format | `.env` file                          | Kubernetes Secrets (`secrets.yaml`) |
| Storage        | Local file (ignored in Git)          | Encrypted & stored in cluster    |
| Usage          | Flask loads with `dotenv`            | Injected via `env.valueFrom`     |
| Security       | Basic (for local dev)                | Stronger isolation & no hardcoding |
