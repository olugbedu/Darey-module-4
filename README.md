# Setup Prometheus Node Exporter on Kubernetes

This README provides a comprehensive guide to setting up Prometheus Node Exporter on a Kubernetes cluster for monitoring node-level metrics.

## Overview

Prometheus Node Exporter is a lightweight application that exposes hardware and operating system metrics from Kubernetes nodes. This setup enables comprehensive monitoring of your cluster's infrastructure health and performance.

## Prerequisites

Before starting, ensure you have:

- ✅ **Kubernetes Cluster**: Working cluster (Minikube, Kind, EKS, AKS, or GKE)
- ✅ **kubectl CLI**: Installed and configured for your cluster
- ✅ **Prometheus**: Basic Prometheus installation running in the cluster
- ✅ **Text Editor**: For modifying YAML files

## Estimated Completion Time

**2-4 hours**

---

## Step-by-Step Implementation

### Step 1: Understanding Node Exporter

Node Exporter is a Prometheus exporter that:
- Runs as a lightweight application on each node
- Exposes hardware and OS metrics via HTTP endpoint (port 9100)
- Collects key metrics including:
  - CPU and memory usage
  - Disk I/O statistics
  - Network statistics
  - Filesystem usage

### Step 2: Deploy Node Exporter as DaemonSet

Create a DaemonSet to ensure Node Exporter runs on every node in your cluster.

#### 2.1 Create the DaemonSet YAML

Create a file named `node-exporter-daemonset.yaml`:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      containers:
      - name: node-exporter
        image: prom/node-exporter:latest
        ports:
        - containerPort: 9100
          name: metrics
        securityContext:
          runAsNonRoot: true
          allowPrivilegeEscalation: false
        resources:
          limits:
            memory: "100Mi"
            cpu: "100m"
          requests:
            memory: "50Mi"
            cpu: "50m"
```

#### 2.2 Deploy the DaemonSet

```bash
kubectl apply -f node-exporter-daemonset.yaml
```

#### 2.3 Verify Deployment

```bash
kubectl get daemonset -n monitoring
```

Expected output should show the DaemonSet running on all nodes.

### Step 3: Configure Prometheus to Scrape Node Exporter

#### 3.1 Update Prometheus Configuration

Edit your Prometheus configuration to add the Node Exporter scrape job:

```yaml
scrape_configs:
- job_name: 'node-exporter'
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_label_app]
    action: keep
    regex: node-exporter
```

#### 3.2 Apply Configuration Changes

Apply the updated Prometheus configuration:

```bash
kubectl apply -f prometheus-config.yaml
```

#### 3.3 Restart Prometheus

Restart the Prometheus deployment to load the new configuration:

```bash
kubectl rollout restart deployment/prometheus -n monitoring
```

### Step 4: Verify Metrics Collection

#### 4.1 Access Prometheus UI

Port-forward to access the Prometheus web interface:

```bash
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
```

Navigate to `http://localhost:9090` in your browser.

#### 4.2 Query Node Exporter Metrics

In the Prometheus UI, test the following query:

```promql
node_cpu_seconds_total
```

This should return CPU metrics from all your cluster nodes.

#### 4.3 Verify All Nodes Are Reporting

Ensure metrics are being collected from all cluster nodes by checking the "Targets" page in Prometheus UI.

### Step 5: Explore Available Metrics

Node Exporter provides numerous metrics. Here are key ones to explore:

#### Memory Metrics
```promql
node_memory_MemAvailable_bytes
```
*Available memory on the node*

#### Filesystem Metrics  
```promql
node_filesystem_avail_bytes
```
*Free space on filesystems*

#### Network Metrics
```promql
node_network_receive_bytes_total
```
*Total network bytes received*

#### Advanced Queries

Use Prometheus expressions for deeper analysis:

```promql
# Network receive rate over 5 minutes
rate(node_network_receive_bytes_total[5m])

# CPU usage percentage
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage percentage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

---

## Validation Checklist

- [ ] Node Exporter DaemonSet is running on all nodes
- [ ] Prometheus is successfully scraping Node Exporter targets
- [ ] Node metrics are visible in Prometheus UI
- [ ] All cluster nodes are reporting metrics
- [ ] Key metrics (CPU, memory, disk, network) are available

## Troubleshooting

### Common Issues

**DaemonSet not starting:**
- Check node resources and ensure sufficient CPU/memory
- Verify the monitoring namespace exists
- Check security contexts and permissions

**Metrics not appearing in Prometheus:**
- Verify Prometheus configuration syntax
- Check if Prometheus has reloaded the configuration
- Ensure network connectivity between Prometheus and Node Exporter pods

**Missing metrics from some nodes:**
- Check if DaemonSet pods are running on all nodes
- Verify node labels and taints
- Check pod logs for errors

### Useful Commands

```bash
# Check DaemonSet status
kubectl get ds node-exporter -n monitoring

# View Node Exporter pod logs
kubectl logs -l app=node-exporter -n monitoring

# Check Prometheus targets
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
# Then visit: http://localhost:9090/targets
```

---

## Next Steps

With Node Exporter successfully deployed, consider these enhancements:

1. **Grafana Integration**: Create dashboards for visual monitoring
2. **Alerting Rules**: Set up alerts for critical metrics thresholds
3. **Service Monitor**: Use Prometheus Operator's ServiceMonitor for easier configuration
4. **Custom Metrics**: Add additional exporters for application-specific monitoring

## Additional Resources

- [Prometheus Node Exporter Documentation](https://github.com/prometheus/node_exporter)
- [Prometheus Configuration Documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
- [Kubernetes DaemonSet Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

---

## Conclusion

You have successfully implemented Prometheus Node Exporter on your Kubernetes cluster, enabling comprehensive node-level monitoring. This foundation supports advanced monitoring strategies and helps maintain cluster health and performance visibility.