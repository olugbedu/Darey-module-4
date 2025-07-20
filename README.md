# Docker Container Management Guide

## Introduction

Docker containers are **portable, self-contained units** that encapsulate applications and their dependencies. They enable consistent environments across development, testing, and production. This guide walks you through the essential steps for managing Docker containers, from pulling images to cleaning up resources.

---

## 1. Running Containers

### Pulling an Image

Before running a container, you may need to **pull the image** from Docker Hub or another registry:

```bash
docker pull ubuntu
```

### Running a Container

To start a container from an image:

```bash
docker run <image_name>
```

**Example:** Running an Ubuntu container:

```bash
docker run ubuntu
```

---

## 2. Customizing Container Behavior

You can modify how containers run using various options:

- **Map Ports:** `-p <host_port>:<container_port>`
- **Set Environment Variables:** `-e VAR=value`
- **Run in Detached Mode:** `-d` (runs in the background)

**Example:** Run an Nginx container, mapping port 8080 on your host to port 80 in the container, in detached mode:

```bash
docker run -d -p 8080:80 nginx
```

---

## 3. Managing Container Lifecycle

| Command                | Description                          |
|------------------------|--------------------------------------|
| `docker start`         | Start a stopped container            |
| `docker stop`          | Stop a running container             |
| `docker restart`       | Restart a container                  |
| `docker rm`            | Remove a container (image persists)  |

---

## 4. Practical Task: Container Operations

### Start a Container and Run a Command

Run a container and execute a command (e.g., display system info):

```bash
docker run ubuntu uname -a
```

### Stop and Inspect

Stop a running container and check its status:

```bash
docker stop <container_id>
docker ps -a
```

### Restart and Observe

Restart the container:

```bash
docker restart <container_id>
```

### Cleanup

Remove the container:

```bash
docker rm <container_id>
```

---

## 5. Key Notes

- **Containers are ephemeral:** Changes inside a container are lost unless you commit them to a new image or use volumes for persistent data.
- **Images persist:** Removing a container does not delete its image from your system.

---

## 6. Common Errors & Fixes

- **"Image not found":** Pull the image first using `docker pull <image_name>`.
- **Port conflicts:** Use a different host port, e.g., `-p 8081:80`.

---

## 7. Next Steps

- **Learn about Docker volumes** for persistent data storage.
- **Explore Docker Compose** for managing multi-container applications.

---
