# Prometheus Node Exporter Setup for Linux Server Monitoring

This README provides a comprehensive guide for setting up Prometheus Node Exporter on a Linux server to monitor system metrics and integrate with Prometheus for real-time monitoring and analysis.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
- [Configuration](#configuration)
- [Verification](#verification)
- [Monitoring and Queries](#monitoring-and-queries)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Overview

Prometheus Node Exporter is a powerful monitoring tool that collects hardware and operating system metrics from Linux servers. This setup enables you to:

- Monitor CPU, memory, disk, and network usage
- Set up real-time alerts for critical system metrics
- Create comprehensive dashboards for system health visualization
- Integrate with Prometheus for centralized metric collection

**Estimated completion time:** 1-2 hours

## Prerequisites

Before starting, ensure you have:

- ✅ A running Linux server with `sudo` privileges
- ✅ A working Prometheus instance (local or remote)
- ✅ Network connectivity allowing Prometheus to reach the server on port 9100
- ✅ Terminal access to the Linux server
- ✅ Text editor access (nano, vim, etc.)
- ✅ Basic familiarity with systemd services

## Installation Steps

### Step 1: Download Node Exporter

Download the latest Node Exporter binary from the official Prometheus GitHub releases:

```bash
curl -LO https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-linux-amd64.tar.gz
```

### Step 2: Extract and Install

Extract the downloaded archive and move the binary to your system PATH:

```bash
# Extract the tarball
tar -xvf node_exporter-linux-amd64.tar.gz

# Move binary to /usr/local/bin/
sudo mv node_exporter-linux-amd64/node_exporter /usr/local/bin/
```

### Step 3: Create System Service

Create a systemd service file for Node Exporter:

```bash
sudo nano /etc/systemd/system/node_exporter.service
```

Add the following configuration:

```ini
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=nobody
ExecStart=/usr/local/bin/node_exporter
Restart=always
WantedBy=multi-user.target
```

### Step 4: Start and Enable Service

Enable and start the Node Exporter service:

```bash
# Reload systemd configuration
sudo systemctl daemon-reload

# Start the service
sudo systemctl start node_exporter

# Enable auto-start on boot
sudo systemctl enable node_exporter
```

### Step 5: Verify Installation

Check that Node Exporter is running correctly:

```bash
# Check service status
sudo systemctl status node_exporter

# Verify metrics endpoint is accessible
curl http://localhost:9100/metrics | head -20
```

## Configuration

### Configure Prometheus Integration

#### Step 1: Update Prometheus Configuration

Edit your Prometheus configuration file:

```bash
sudo nano /etc/prometheus/prometheus.yml
```

#### Step 2: Add Node Exporter Target

Add the following scrape configuration:

```yaml
scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['your-server-ip:9100']
```

**Note:** Replace `your-server-ip` with:
- Your actual server IP address for remote monitoring
- `localhost` if Prometheus and Node Exporter are on the same machine

#### Step 3: Restart Prometheus

Apply the configuration changes:

```bash
sudo systemctl restart prometheus
```

## Verification

### Verify Node Exporter Access

1. **Web Browser Test:**
   - Navigate to `http://your-server-ip:9100/metrics`
   - You should see a page with various system metrics

2. **Command Line Test:**
   ```bash
   curl http://localhost:9100/metrics | grep "node_cpu"
   ```

### Verify Prometheus Integration

1. **Access Prometheus Web UI:**
   - Navigate to `http://prometheus-server-ip:9090`

2. **Check Targets:**
   - Go to Status → Targets
   - Verify that the `node-exporter` target shows as "UP"

3. **Test Basic Query:**
   - In the Prometheus query interface, try: `node_cpu_seconds_total`

## Monitoring and Queries

### Essential Metrics to Monitor

#### CPU Usage
```promql
# Current CPU usage rate
rate(node_cpu_seconds_total[5m])

# CPU usage by mode
rate(node_cpu_seconds_total{mode="user"}[5m])
```

#### Memory Monitoring
```promql
# Available memory in bytes
node_memory_MemAvailable_bytes

# Memory usage percentage
100 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100)
```

#### Disk Space
```promql
# Available disk space
node_filesystem_avail_bytes

# Disk usage percentage
100 - (node_filesystem_avail_bytes / node_filesystem_size_bytes * 100)
```

#### Network Traffic
```promql
# Network bytes received
rate(node_network_receive_bytes_total[5m])

# Network bytes transmitted
rate(node_network_transmit_bytes_total[5m])
```

### Sample Queries for Analysis

#### CPU Analysis Over Time
```promql
rate(node_cpu_seconds_total[5m])
```

#### Memory Utilization Trend
```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

#### Disk I/O Operations
```promql
rate(node_disk_reads_completed_total[5m])
rate(node_disk_writes_completed_total[5m])
```

## Troubleshooting

### Common Issues and Solutions

#### Service Won't Start
```bash
# Check service logs
sudo journalctl -u node_exporter -f

# Verify binary permissions
ls -la /usr/local/bin/node_exporter
```

#### Port 9100 Not Accessible
```bash
# Check if port is listening
sudo netstat -tlnp | grep 9100

# Check firewall settings
sudo ufw status
sudo firewall-cmd --list-ports
```

#### Metrics Not Appearing in Prometheus
1. Verify Prometheus configuration syntax:
   ```bash
   promtool check config /etc/prometheus/prometheus.yml
   ```

2. Check Prometheus logs:
   ```bash
   sudo journalctl -u prometheus -f
   ```

3. Verify network connectivity:
   ```bash
   telnet your-server-ip 9100
   ```

### Performance Considerations

- Node Exporter has minimal resource overhead
- Default scrape interval is 15 seconds
- Consider adjusting scrape intervals for high-frequency monitoring
- Monitor Prometheus storage requirements as metrics accumulate

## Next Steps

### Recommended Enhancements

1. **Set Up Alerting:**
   - Configure Alertmanager for critical metric thresholds
   - Create alert rules for high CPU, low memory, or disk space issues

2. **Add Visualization:**
   - Install Grafana for advanced dashboards
   - Import community Node Exporter dashboards

3. **Extend Monitoring:**
   - Add custom metrics using textfile collector
   - Monitor additional services with specific exporters

4. **Security Hardening:**
   - Configure HTTPS for metrics endpoints
   - Implement authentication if needed
   - Restrict network access to monitoring ports

### Useful Resources

- [Prometheus Node Exporter Documentation](https://github.com/prometheus/node_exporter)
- [Prometheus Query Language (PromQL) Guide](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Grafana Node Exporter Dashboard Templates](https://grafana.com/grafana/dashboards/?search=node%20exporter)

---

**Project Status:** ✅ Complete - Ready for production use

**Last Updated:** July 2025

**Tested On:** Ubuntu 20.04