# Gatus Uptime Monitoring Setup

A comprehensive guide to configuring uptime monitoring using Gatus, a simple yet powerful tool for monitoring the availability and performance of services and websites.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Testing](#testing)
- [Alerting](#alerting)
- [Dashboard Customization](#dashboard-customization)
- [Troubleshooting](#troubleshooting)
- [Conclusion](#conclusion)

## Overview

Gatus is a lightweight uptime monitoring tool that helps ensure your services and websites are available and performing as expected. This project demonstrates how to:

- Set up Gatus using Docker
- Monitor multiple endpoints
- Configure downtime alerts
- Customize the monitoring dashboard

**Estimated Time:** 1-2 hours

## Prerequisites

Before starting, ensure you have:

### Basic Knowledge
- Familiarity with HTTP services and APIs
- Understanding of YAML configuration files
- Basic command line experience

### Required Tools
- Docker installed on your machine
- Text editor for configuration files
- Internet access for testing live endpoints

### System Requirements
- Any machine capable of running Docker
- Minimum 512MB RAM
- 100MB disk space

## Installation

### Step 1: Install Docker

If Docker is not already installed, follow the official installation guide for your operating system:
- [Docker Desktop for Windows](https://docs.docker.com/desktop/windows/install/)
- [Docker Desktop for Mac](https://docs.docker.com/desktop/mac/install/)
- [Docker Engine for Linux](https://docs.docker.com/engine/install/)

### Step 2: Pull Gatus Docker Image

```bash
docker pull twinproduction/gatus
```

### Step 3: Create Configuration Directory

```bash
mkdir gatus && cd gatus
mkdir config
```

### Step 4: Start Gatus Container

```bash
docker run -d -p 8080:8080 --name gatus -v $(pwd)/config:/config twinproduction/gatus
```

### Step 5: Verify Installation

Open your browser and navigate to `http://localhost:8080` to access the Gatus dashboard.

## Configuration

### Basic Configuration File

Create a `config.yaml` file in the `gatus/config` directory with the following content:

```yaml
endpoints:
  - name: Example website
    url: "https://example.com"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
```

### Configuration Parameters Explained

- **name**: Human-readable name for the endpoint
- **url**: The URL to monitor
- **interval**: How often to check the endpoint (in seconds)
- **conditions**: Success criteria for the endpoint

### Apply Configuration Changes

After making changes to `config.yaml`, restart the Gatus container:

```bash
docker restart gatus
```

## Testing

### Adding Multiple Endpoints

Expand your `config.yaml` to monitor multiple services:

```yaml
endpoints:
  - name: Example website
    url: "https://example.com"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
      
  - name: GitHub
    url: "https://github.com"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
```

### Simulating Failures

To test failure detection, add a non-existent endpoint:

```yaml
  - name: Nonexistent
    url: "https://thiswebsitedoesnotexist.com"
    interval: 60s
    conditions:
      - "[STATUS] == 200"
```

### Verification Steps

1. Restart Gatus: `docker restart gatus`
2. Check the dashboard at `http://localhost:8080`
3. Verify that all endpoints appear
4. Observe the behavior of the non-existent endpoint

## Alerting

### Slack Integration

#### Prerequisites
1. Create a Slack workspace or use an existing one
2. Create a Slack webhook URL following [Slack's webhook guide](https://api.slack.com/messaging/webhooks)

#### Configuration

Add the alerts section to your `config.yaml`:

```yaml
endpoints:
  - name: Example website
    url: "https://example.com"
    interval: 60s
    conditions:
      - "[STATUS] == 200"

alerts:
  - type: slack
    url: "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
    failure-threshold: 2
    success-threshold: 2
```

#### Alert Parameters

- **type**: Notification method (slack, email, etc.)
- **url**: Webhook URL for notifications
- **failure-threshold**: Number of consecutive failures before alerting
- **success-threshold**: Number of consecutive successes to resolve alert

### Testing Alerts

1. Configure a valid endpoint with alerts
2. Temporarily modify the URL to cause a failure
3. Wait for the failure threshold to be reached
4. Check your Slack channel for notifications
5. Restore the correct URL and verify recovery notification

## Dashboard Customization

### Accessing the Dashboard

Navigate to `http://localhost:8080` to view:
- Real-time endpoint status
- Response time graphs
- Uptime statistics
- Historical data

### Customization Options

You can customize the dashboard by adding these sections to your `config.yaml`:

```yaml
ui:
  title: "My Service Monitor"
  description: "Monitoring critical services"
  
endpoints:
  # Your endpoints here
```

### Advanced Monitoring

#### Custom Conditions

```yaml
endpoints:
  - name: API Health Check
    url: "https://api.example.com/health"
    interval: 30s
    conditions:
      - "[STATUS] == 200"
      - "[RESPONSE_TIME] < 1000"
      - "[BODY].status == UP"
```

#### Different Check Intervals

```yaml
endpoints:
  - name: Critical Service
    url: "https://critical.example.com"
    interval: 15s
    conditions:
      - "[STATUS] == 200"
      
  - name: Less Critical Service
    url: "https://other.example.com"
    interval: 300s
    conditions:
      - "[STATUS] == 200"
```

## Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check container logs
docker logs gatus

# Verify port availability
netstat -tulpn | grep :8080
```

#### Configuration Not Loading
```bash
# Verify file location and permissions
ls -la config/
cat config/config.yaml

# Check YAML syntax
python -c "import yaml; yaml.safe_load(open('config/config.yaml'))"
```

#### Endpoints Not Responding
- Verify URLs are accessible from your network
- Check firewall settings
- Ensure target services are running

### Useful Commands

```bash
# View container status
docker ps

# Stop Gatus
docker stop gatus

# Remove container (keeps config)
docker rm gatus

# View real-time logs
docker logs -f gatus

# Update Gatus image
docker pull twinproduction/gatus
docker stop gatus && docker rm gatus
# Then restart with original run command
```

## Best Practices

### Configuration Management
- Keep configuration files in version control
- Use meaningful endpoint names
- Set appropriate check intervals (balance between responsiveness and resource usage)
- Test configurations before deploying to production

### Monitoring Strategy
- Monitor critical user-facing services more frequently
- Set reasonable failure thresholds to avoid alert fatigue
- Include both availability and performance checks
- Monitor dependencies and external services

### Security Considerations
- Secure webhook URLs
- Limit network access to monitoring endpoints
- Regularly update Docker images
- Use environment variables for sensitive configuration

## Production Deployment

### Docker Compose Example

Create a `docker-compose.yml` file:

```yaml
version: '3.8'
services:
  gatus:
    image: twinproduction/gatus
    container_name: gatus
    ports:
      - "8080:8080"
    volumes:
      - ./config:/config
    restart: unless-stopped
```

### Running in Production

```bash
# Start with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f gatus

# Update
docker-compose pull && docker-compose up -d
```

## Conclusion

This guide covered the complete setup and configuration of Gatus for uptime monitoring, including:

✅ Installation using Docker  
✅ Basic endpoint configuration  
✅ Multi-endpoint monitoring  
✅ Failure simulation and testing  
✅ Slack alert integration  
✅ Dashboard customization  
✅ Troubleshooting common issues  

With Gatus properly configured, you can now:
- Monitor multiple services and websites
- Receive timely alerts when services go down
- Track uptime statistics and performance metrics
- Expand monitoring coverage as your infrastructure grows

### Next Steps

- Explore additional notification channels (email, Discord, PagerDuty)
- Implement more complex health checks with custom conditions
- Set up monitoring for internal services and APIs
- Consider deploying Gatus in a production environment with proper security measures

### Additional Resources

- [Official Gatus Documentation](https://gatus.io/)
- [Docker Documentation](https://docs.docker.com/)
- [YAML Syntax Guide](https://yaml.org/spec/1.2/spec.html)
- [Slack Webhook Setup](https://api.slack.com/messaging/webhooks)