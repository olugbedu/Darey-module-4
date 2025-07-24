# Setting up Minikube on Linux

This README provides a comprehensive guide for setting up Minikube on a Linux system for local Kubernetes development and learning.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Goals](#project-goals)
- [Understanding Kubernetes](#understanding-kubernetes)
- [What is Minikube?](#what-is-minikube)
- [Installation Steps](#installation-steps)
  - [Step 1: Update System Packages](#step-1-update-system-packages)
  - [Step 2: Install Docker](#step-2-install-docker)
  - [Step 3: Install Minikube](#step-3-install-minikube)
  - [Step 4: Start Minikube](#step-4-start-minikube)
  - [Step 5: Install kubectl](#step-5-install-kubectl)
- [Verification](#verification)
- [Next Steps](#next-steps)
- [Troubleshooting](#troubleshooting)

## Overview

This project focuses on setting up Minikube for Container Orchestration with Kubernetes on a Linux system. Minikube provides a local Kubernetes environment that's perfect for development, testing, and learning Kubernetes concepts without the complexity of a full production cluster.

## Prerequisites

Before starting this setup, ensure you have:

- **Hardware Requirements:**
  - 2 CPUs or more
  - 2GB of free memory
  - 20GB of free disk space

- **Software Requirements:**
  - Linux OS (Ubuntu/Debian-based system recommended)
  - Terminal access with administrative privileges
  - Completion of foundations core program 1 & 2 projects

![](./minikube.png)

## Project Goals

By completing this setup, you will have:

- Gained a comprehensive understanding of Kubernetes and its fundamental concepts
- Mastered the usage of Minikube for local Kubernetes cluster deployment and experimentation
- Acquired hands-on experience with Docker and containerization principles
- A functional local Kubernetes environment ready for application deployment and testing

## Understanding Kubernetes

Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. Think of it as a skilled event coordinator managing multiple chefs (containers) to ensure perfect timing and coordination in a complex culinary event.

### Key Components

**Master Node Components:**
- **etcd**: Distributed key-value store for cluster data
- **API Server**: Front-end interface for the Kubernetes control plane
- **Scheduler**: Assigns workloads to nodes based on resource requirements
- **Controller Manager**: Maintains desired cluster state

**Worker Node Components:**
- **Kubelet**: Communicates with master and manages containers
- **Kube Proxy**: Handles network routing and policies
- **Docker**: Container runtime environment

## What is Minikube?

Minikube is an open-source tool that enables you to run Kubernetes clusters locally on your machine. It creates a single-node Kubernetes cluster inside a virtual machine, providing a user-friendly playground for safely building and testing applications before production deployment.

## Installation Steps

### Step 1: Update System Packages

First, refresh your package list to ensure you have access to the latest software versions:

```bash
sudo apt-get update
```

This command updates the package index on your Debian-based system.

### Step 2: Install Docker

Minikube requires Docker as a driver and for pulling base images. Follow these steps to install Docker:

#### 2.1 Install Prerequisites

```bash
sudo apt-get install ca-certificates curl gnupg
```

This installs essential packages including certificate authorities, curl for data transfer, and GNU Privacy Guard for secure communication.

#### 2.2 Set up Docker GPG Key

Create a directory for Docker keyrings:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Download and add Docker's official GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Set appropriate permissions:

```bash
sudo chmod -R /etc/apt/keyrings/docker.gpg
```

#### 2.3 Add Docker Repository

Add Docker's APT repository to your system:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update package index again:

```bash
sudo apt-get update
```

#### 2.4 Install Docker Engine

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### 2.5 Verify Docker Installation

Check that Docker is running properly:

```bash
sudo systemctl status docker
```

### Step 3: Install Minikube

#### 3.1 Download Minikube

Download the latest Minikube .deb package:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
```

> **Note:** If you encounter errors during download, reach out to technical support.

#### 3.2 Install Minikube

Install the downloaded package using dpkg:

```bash
sudo dpkg -i minikube_latest_amd64.deb
```

**Expected Output:**
```
(Reading database ... 63745 files and directories currently installed.)
Preparing to unpack minikube_latest_amd64.deb ...
Unpacking minikube (1.32.0-0) ...
Setting up minikube (1.32.0-0) ...
```

### Step 4: Start Minikube

Start your Minikube cluster using Docker as the driver:

```bash
minikube start --driver=docker
```
![](./minikube.png)

**Expected Startup Process:**
```
🏃 Booting up control plane ...
🤖 Configuring RBAC rules ...
🔗 Configuring bridge CNI (Container Networking Interface) ...
📦 Using image gcr.io/k8s-minikube/storage-provisioner:v5
🔎 Verifying Kubernetes components ...
🌟 Enabled addons: default-storageclass, storage-provisioner
💡 kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'
🏁 Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

### Step 5: Install kubectl

kubectl is the command-line interface for interacting with Kubernetes clusters:

```bash
sudo snap install kubectl --classic
```

**Expected Output:**
```
kubectl 1.28.5 from Canonical/ installed
```

## Verification

Verify your installation by checking the cluster status:

```bash
kubectl cluster-info
```

Check that all system pods are running:

```bash
kubectl get pods -A
```

Verify Minikube status:

```bash
minikube status
```

## Next Steps

Now that you have Minikube running, you can:

1. **Deploy your first application:**
   ```bash
   kubectl create deployment hello-minikube --image=gcr.io/google_containers/echoserver:1.4
   ```

2. **Expose the application:**
   ```bash
   kubectl expose deployment hello-minikube --type=NodePort --port=8080
   ```

3. **Access the Minikube dashboard:**
   ```bash
   minikube dashboard
   ```

4. **Practice Kubernetes concepts:**
   - Create and manage pods
   - Work with services and deployments
   - Explore ConfigMaps and Secrets
   - Practice scaling applications

## Troubleshooting

### Common Issues and Solutions

**1. Docker Permission Denied:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

**2. Minikube Won't Start:**
```bash
minikube delete
minikube start --driver=docker --force
```

**3. Check Minikube Logs:**
```bash
minikube logs
```

**4. Reset Minikube:**
```bash
minikube stop
minikube delete --all
minikube start --driver=docker
```

### Useful Commands

- **Stop Minikube:** `minikube stop`
- **Delete Minikube:** `minikube delete`
- **Get Minikube IP:** `minikube ip`
- **SSH into Minikube:** `minikube ssh`
- **Open Dashboard:** `minikube dashboard`

## Conclusion

You now have a fully functional local Kubernetes environment using Minikube on your Linux system. This setup provides an excellent foundation for learning Kubernetes concepts, developing containerized applications, and testing deployments before moving to production environments.

---

**Created by:** [Your Name]  
**Date:** [Current Date]  
**Version:** 1.0