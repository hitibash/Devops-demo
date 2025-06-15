# Monitoring Setup

This folder contains all configurations needed to deploy monitoring tools for the DevOps Demo project using Helm.

## Overview

The monitoring stack includes:

- **Prometheus**: Collects and stores metrics from Kubernetes nodes and services.
- **Grafana**: Visualizes those metrics in a rich dashboard interface.
- **Node Exporter Dashboard (ID 1860)**: Provides detailed insights into CPU, memory, disk, and network usage of Kubernetes nodes.

## Structure

```
monitoring/
├── dashboards/
│   └── node-exporter-full.json       # Exported Grafana dashboard
├── prometheus-values.yaml            # Custom values for Prometheus Helm chart
└── grafana-values.yaml               # Custom values for Grafana Helm chart
```

## Installation

### 1. Add Helm Repositories

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

### 2. Create the monitoring namespace:

```bash
kubectl create namespace monitoring
```

### 3. Install Prometheus:


Install with default values:

```bash
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring
```

### 4. Install Grafana:

With defaults:

```bash
helm install grafana grafana/grafana \
  --namespace monitoring
```

### 5. Access Grafana:

Grafana is exposed via NodePort. Run:

```bash
kubectl get svc -n monitoring
```

Find the NodePort for Grafana and visit:  
`http://<YOUR_NODE_IP>:<NODE_PORT>` in your browser.

### 6. Import Dashboard:

In Grafana, go to:  
**Dashboards → Import** and upload `node-exporter-full.json` from the `dashboards/` folder.

---

## Note on Application-Level Monitoring

This setup provides **infrastructure-level metrics** (CPU, memory, etc.).

For **application-level monitoring** (e.g., request rate, response time, error counts), it is recommended to integrate:

- Flask with `prometheus_client`
- A custom `/metrics` endpoint in the Flask app

> I avoided this in the current setup to keep the application code untouched. However, it can be added in future improvements.

---

## Resources

- [Prometheus Helm Chart](https://github.com/prometheus-community/helm-charts)
- [Grafana Helm Chart](https://github.com/grafana/helm-charts)
- [Node Exporter Full Dashboard (ID 1860)](https://grafana.com/grafana/dashboards/1860)