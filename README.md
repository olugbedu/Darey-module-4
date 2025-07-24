# Kubernetes Networking and Multi-Container Pod Demonstration

This project demonstrates core concepts of Kubernetes networking through the deployment of a multi-container pod. The configuration and steps below highlight how networking works within a Kubernetes pod, using tools like `kubectl`, `nginx`, and `busybox`.

---

## Key Concepts in Kubernetes Networking

### 1. Pod Networking
- All containers within a pod share the same network namespace.
- They can communicate via `localhost`.

### 2. Service Networking
- Kubernetes Services expose a set of Pods under one stable endpoint.
- They can be internal (ClusterIP) or external (LoadBalancer, NodePort, Ingress).

### 3. Pod-to-Pod Communication
- Kubernetes uses an overlay network that allows direct communication across nodes.

### 4. Ingress
- Ingress manages external access to services in the cluster using rules.

### 5. Network Policies
- Policies allow fine-grained control over pod communication.

### 6. Container Network Interface (CNI)
- Kubernetes supports multiple CNI plugins for extensible network capabilities.

---

## YAML Snippet for Multi-Container Pod

```yaml
apiVersion: v1  
kind: Pod  
metadata:  
  name: multi-container-pod  
spec:  
  containers:  
  - name: container-1  
    image: nginx  
  - name: container-2  
    image: busybox  
    command:  
      - /bin/sh  
      - -c  
      - "while true; do echo 'Hello from Container 2' >> /usr/share/nginx/html/index.html; sleep 10; done"
```

### Explanation
- **container-1** runs an Nginx server.
- **container-2** appends text into the Nginx HTML file every 10 seconds.
- They share a volume and network namespace.

---

## Steps to Deploy and Verify

### 1. Apply Configuration

```bash
kubectl apply -f multi-container-pod.yaml
```

**Output:**
```bash
pod/multi-container-pod created
```

### 2. Check Pod Status

```bash
kubectl get pods
```

**Output:**
```bash
NAME                  READY   STATUS    RESTARTS   AGE
multi-container-pod   2/2     Running   0          2m
```

### 3. View Logs

#### Container-1 (nginx):
```bash
kubectl logs multi-container-pod -c container-1
```

#### Container-2 (busybox):
```bash
kubectl logs multi-container-pod -c container-2
```

### 4. Exec into BusyBox to Verify Nginx Content

```bash
kubectl exec -it multi-container-pod -c container-2 -- /bin/sh
```

Then inside the shell:
```sh
cd /usr/share/nginx/html
cat index.html
```

**Output:**
```
Hello from Container 2
Hello from Container 2
... repeated ...
```

---

## Summary

- Both containers within the pod share a network namespace.
- BusyBox writes to a file served by Nginx.
- Nginx serves the HTML which can be accessed internally via `localhost`.

---

## Learning Outcome

This task reinforces how Kubernetes pod-level networking works and how containers within a pod can interact and share data.
