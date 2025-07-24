
# Working with Kubernetes Pods and Containers

## Pods in Kubernetes

### Definition and Purpose
A Pod in Kubernetes is like a small container for running parts of an application. It can have one or more containers inside it that work closely together. These containers share the same network and storage, which makes them communicate and cooperate easily. A Pod is the smallest thing you can create and manage in Kubernetes. In Minkabe, which is a tool to run Kubernetes easily, Pods are used to set up, change the size, and control applications.

---

## Prerequisites

- Install Docker
- Install Minikube: https://minikube.sigs.k8s.io/docs/start/
- Install kubectl: https://kubernetes.io/docs/tasks/tools/

Start Minikube:
```bash
minikube start
```

---

## Step 1: Define a Pod with Containers

Create a file named `pod.yaml` with the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: myapp-container
      image: nginx
      ports:
        - containerPort: 80
```

---

## Step 2: Deploy the Pod

Run the command below to apply the YAML configuration and deploy the Pod:

```bash
kubectl apply -f pod.yaml
```

---

## Step 3: View Pods

List all running Pods:

```bash
kubectl get pods
```

---

## Step 4: Inspect a Pod

To describe the Pod and get detailed info (like events, state, container logs):

```bash
kubectl describe pod myapp-pod
```

---

## Step 5: Interact with the Pod

To execute commands inside the Pod:

```bash
kubectl exec -it myapp-pod -- /bin/bash
```

---

## Step 6: Delete the Pod

To delete the Pod:

```bash
kubectl delete pod myapp-pod
```

---

## Notes

- Pods are **ephemeral** – changes made inside a running Pod will be lost if it’s deleted.
- Use **Deployments** for managing Pod replicas and auto-recovery.
- For persistent data, consider using **Volumes**.

---

## Conclusion

This guide demonstrated how to create, inspect, and delete Kubernetes Pods using `kubectl` on Minikube, including YAML configuration for defining containers inside a Pod.
