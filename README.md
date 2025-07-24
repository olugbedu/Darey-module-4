# Kubernetes Deployment and Service with YAML

## Introduction to YAML

A Kubernetes YAML file is a configuration file written in YAML format that describes Kubernetes resources. These files specify the desired state of resources like Pods, Services, and Deployments. YAML is human-readable and uses indentation to denote structure [[4]].

### Basic YAML Structure

YAML supports several data types and structures:

- **Strings:**
  ```yaml
  name: State line
  ID: org
  ```

- **Numbers:**
  ```yaml
  args: 25
  ```

- **Booleans:**
  ```yaml
  Kubernetes: true
  ```

- **Lists (arrays):**
  ```yaml
  fruits:
    - apple
    - banana
    - orange
  ```

- **Maps (key-value pairs):**
  ```yaml
  person:
    name: Alice
    age: 30
  ```

- **Nested Structures:**
  ```yaml
  employees:
    name: John Doe
    position: developer
    skills:
      - Python
      - JavaScript
  ```

- **Comments:**
  ```yaml
  # This is a comment
  key: value
  ```

- **Multiline Strings:**
  ```yaml
  description: |
    This is a multiline
    string in YAML.
  ```

---

## Deploying Applications in Kubernetes

### Deployment in Kubernetes

A Deployment provides a blueprint for the desired state of your app and ensures Kubernetes manages it correctly. It allows you to declaratively manage and scale a group of identical pods [[2]][[3]].

### Services in Kubernetes

Kubernetes Services expose Pods to the network:

- **ClusterIP:** Default, internal access only.
- **NodePort:** Exposes service on a static port.
- **LoadBalancer:** Uses external load balancer.

---

## Working With YAML Files

1. **Create a directory** named `my-nginx-yaml`.
2. **Inside, create `nginx-deployment.yaml`:**

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: my-nginx-deployment
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: my-nginx
      template:
        metadata:
          labels:
            app: my-nginx
        spec:
          containers:
          - name: my-nginx
            image: dareyregistry/my-nginx:1.0
            ports:
            - containerPort: 80
    ```

3. **Then, create `nginx-service.yaml`:**

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: my-nginx-service
    spec:
      selector:
        app: my-nginx
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
      type: NodePort
    ```

---

## Apply and Verify

### Apply YAMLs

```bash
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
```

### 🔍 Verify Resources

```bash
kubectl get deployments
kubectl get services
```

**Expected output:**

```bash
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
my-nginx-deployment    1/1     1            1           4m

NAME                 TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
my-nginx-service     NodePort   10.111.184.164  <none>        80:31241/TCP     4m
```

---

## Accessing the Application

```bash
minikube service my-nginx-service --url
```

**Output:**

```bash
http://127.0.0.1:55077
```

> You can open this URL in your browser to view the Nginx page.

