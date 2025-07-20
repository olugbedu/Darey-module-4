# Docker and Containers - Introduction and Setup Guide

## Introduction to Docker and Containers

### What are Containers?
In the realm of software development and deployment, developers frequently faced the "it works on my machine" issue. Docker emerged in 2013, created by Solomon Hykes, to solve this problem using containers.

Containers bundle everything an application needs (code, dependencies, config) so it runs the same on any environment—be it development, testing, or production.

### Why Docker?
- **Portability:** Applications run consistently across different environments.
- **Resource Efficiency:** Containers share the OS kernel, unlike full VMs.
- **Rapid Deployment & Scaling:** Easily spin containers up or down as needed.

## Docker vs Virtual Machines

| Feature | Docker Containers | Virtual Machines |
|--------|------------------|------------------|
| Virtualization | OS-level | Hardware-level |
| Resource Use | Lightweight | Heavy |
| Speed | Faster startup | Slower |
| Isolation | Shared kernel | Full isolation |
| Use Case | Microservices, fast deployments | Multi-OS environments, strong isolation |

## Target Audience

- **DevOps Engineers**
- **Software Developers**
- **Cloud Engineers & QA Analysts**
- **Tech Enthusiasts and Students**

## Prerequisites

- Completed TechOps Career Essentials & Advanced TechOps courses.
- Comfortable with Linux commands.
- Basic understanding of cloud computing and VMs.

## Project Goals

1. Understand containers and isolation.
2. Learn Docker features and best practices.
3. Explore Docker vs VMs for efficiency.
4. Use Docker across different environments.
5. Deploy and scale apps using Docker.

---

# Getting Started with Docker

## Installing Docker (Ubuntu 20.04)

### 1. Update Packages
```bash
sudo apt-get update
```

### 2. Install Dependencies
```bash
sudo apt-get install ca-certificates curl gnupg
```

### 3. Add Docker’s Official GPG Key
```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### 4. Set Up Docker Repository
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 5. Install Docker Engine
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 6. Check Docker Status
```bash
sudo systemctl status docker
```

### 7. Optional: Run Docker Without `sudo`
```bash
sudo usermod -aG docker ubuntu
```

## Running Your First Container: Hello World

```bash
docker run hello-world
```

- **Pulls the image** from Docker Hub (if not found locally).
- **Creates a container** from the image.
- **Starts the container** and prints a hello message.

### View Images
```bash
docker images
```

---

# Basic Docker Commands

### Run a Container
```bash
docker run nginx
```

### List Running Containers
```bash
docker ps
```

### List All Containers (incl. stopped)
```bash
docker ps -a
```

### Stop a Container
```bash
docker stop <CONTAINER_ID>
```

### Pull an Image
```bash
docker pull ubuntu
```

### Push an Image
```bash
docker push your-username/image-name
```

### List Local Images
```bash
docker images
```

### Remove Image
```bash
docker rmi <IMAGE_ID>
```

---

## Summary

With Docker installed and your first container running, you've taken your first steps into the world of containerization. You now understand:

- What containers are and why they matter.
- How Docker improves development workflows.
- Basic commands to manage Docker containers and images.

Next steps? Explore Dockerfiles, custom image builds, networking, and orchestration tools like Docker Compose and Kubernetes.

Happy Docking! 🐳
