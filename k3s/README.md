# Kubernetes Deployment with K3s

This folder contains all Kubernetes manifests and deployment logic used to run the application stack locally using [K3s](https://k3s.io/), a lightweight Kubernetes distribution designed for simplicity and efficiency.

---

##  Services & Components

### 1. **MySQL**
- Deployed using a `Deployment`, `Service`, and `PersistentVolumeClaim`
- Credentials and database name are injected via **Kubernetes Secrets**
- A Kubernetes **Job** is used to initialize the schema and insert the default admin user

### 2. **Flask App**
- Deployed with 2 replicas for demonstration of scaling
- Connects to MySQL using credentials injected as environment variables from Secrets
- Exposed via a `NodePort` service

### 3. **Secrets**
- All sensitive information (e.g. DB passwords) is stored securely using Kubernetes Secrets
- Referenced using `valueFrom.secretKeyRef` in both the app and init-job deployments

---

## Example Output

### Pods

```bash
NAME                         READY   STATUS      RESTARTS      AGE
flask-app-685646f95b-84jwj   1/1     Running     2 (87m ago)   25h
flask-app-685646f95b-v8ww6   1/1     Running     2 (87m ago)   25h
mysql-7555987f87-wwf9m       1/1     Running     5 (87m ago)   44h
mysql-init-zkzph             0/1     Completed   0             25h
```

### Services

```bash
NAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
flask-service   NodePort    10.43.81.37    <none>        5000:30007/TCP   2d4h
kubernetes      ClusterIP   10.43.0.1      <none>        443/TCP          41d
mysql           ClusterIP   10.43.128.15   <none>        3306/TCP         29h
```


##  Notes

- Helm was not used for app/db to avoid hiding complexity.
- Monitoring (Prometheus + Grafana) **is** managed via Helm — see the [`monitoring/`](../monitoring/) folder for details.
- All resources are deployed using standard manifest files with `kubectl apply` from the `k3s/` directory.
- The Flask app and MySQL database are deployed as separate services, allowing independent scaling and management.
