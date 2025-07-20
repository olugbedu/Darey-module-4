# Working with Docker Images – Learning Path Guide

This guide walks through the steps taken to understand and implement Docker-based workflows, including image creation, container deployment, and Docker Hub integration. It provides hands-on instructions aligned with the learning objectives.

---

## 1. Introduction to Docker Images

Docker images are portable packages that contain everything needed to run an application—code, runtime, libraries, and system tools.

### Key Concepts

- **Images** are built using instructions in a `Dockerfile`.
- **Docker Hub** serves as a registry of prebuilt Docker images.

### Useful Commands

```bash
docker pull nginx             # Pull the official NGINX image
docker search nginx           # Search Docker Hub for images
docker images                 # List downloaded images
```

---

## 2. Creating a Dockerfile

The `Dockerfile` is a configuration script used to build Docker images. Below is a sample Dockerfile that sets up an NGINX web server.

### Example Dockerfile

```Dockerfile
FROM nginx:latest
WORKDIR /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/
EXPOSE 80
```

### Breakdown

- `FROM`: Specifies the base image (nginx).
- `WORKDIR`: Sets the working directory in the container.
- `COPY`: Transfers files into the container.
- `EXPOSE`: Documents the app’s port.

---

## 3. Building and Running Containers

### Step-by-Step

1. **Build the Image**

```bash
docker build -t my-nginx-image .
```

2. **Run the Container**

```bash
docker run -d -p 8080:80 my-nginx-image
```

3. **Check Running Containers**

```bash
docker ps
```

This command verifies that your container is up and running on port `8080`.

---

## 4. Pushing Images to Docker Hub

To share your Docker image:

1. **Create a Docker Hub account and repository**  
2. **Tag the Image**

```bash
docker tag my-nginx-image yourusername/my-nginx-image:latest
```

3. **Push to Docker Hub**

```bash
docker push yourusername/my-nginx-image:latest
```

---

## 5. Managing Security and Networking

When deploying on cloud servers (e.g., AWS EC2):

- Ensure **security groups** allow HTTP traffic (port 80).
- Manage containers with Docker commands:

```bash
docker stop <container_id>    # Stop container
docker rm <container_id>      # Remove container
```

---

## 6. Additional Notes

- **Datasets and Testing**: Build images with included datasets for full testing.
- **Remote Access**: Use `http://datasheet.com/` for component references.
- **Comment your steps** for documentation and reproducibility.

---

## Key Docker Commands Summary

| Command                                      | Description                                 |
|---------------------------------------------|---------------------------------------------|
| `docker pull <image>`                       | Download an image from Docker Hub           |
| `docker build -t <name> .`                  | Build image from Dockerfile                 |
| `docker run -d -p <host>:<container> <img>` | Run container on specified ports            |
| `docker tag <img> <user>/<repo>:<tag>`      | Tag image for pushing to Docker Hub         |
| `docker push <user>/<repo>:<tag>`           | Push image to Docker Hub                    |
| `docker stop <container_id>`                | Stop a running container                    |
| `docker rm <container_id>`                  | Remove a stopped container                  |

---

## Outcome

By following these steps, a basic understanding of Docker workflows—image creation, container management, security, and deployment—has been achieved.

---