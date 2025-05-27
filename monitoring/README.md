
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

1. **Create the monitoring namespace:**
   ```bash
   kubectl create namespace monitoring
   ```

2. **Install Prometheus:**
   ```bash
   helm install prometheus prometheus-community/prometheus      --namespace monitoring      -f monitoring/prometheus-values.yaml
   ```

3. **Install Grafana:**
   ```bash
   helm install grafana grafana/grafana      --namespace monitoring      -f monitoring/grafana-values.yaml
   ```

4. **Access Grafana:**

   Grafana is exposed via NodePort. Run:

   ```bash
   kubectl get svc -n monitoring
   ```

   Find the NodePort for `grafana` and visit `http://<YOUR_NODE_IP>:<NODE_PORT>` in your browser.

5. **Import Dashboard:**

   In Grafana, go to **Dashboards → Import** and upload `node-exporter-full.json` from the `dashboards/` folder.

## Note on Application-Level Monitoring

This setup provides infrastructure-level metrics (CPU, memory, etc.). For **application-level metrics** (e.g., request rate, response time, error counts), it is recommanded to integrate tools like:

- Flask with Prometheus client (`prometheus_client`)
- Custom `/metrics` endpoint in the Flask app

We avoided this in the current setup to keep the application code untouched. However, it can be added in future improvements.

---

## Resources

- [Prometheus Helm Chart](https://github.com/prometheus-community/helm-charts)
- [Grafana Helm Chart](https://github.com/grafana/helm-charts)
- [Node Exporter Full Dashboard (ID 1860)](https://grafana.com/grafana/dashboards/1860)
