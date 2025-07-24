
# Working with Kubernetes Pods and Containers

## Pods in Kubernetes

### Definition and Purpose
A Pod in Kubernetes is like a small container for running parts of an application. It can have one or more containers inside it that work closely together. These containers share the same network and storage, which makes them communicate and cooperate easily. A Pod is the smallest thing you can create and manage in Kubernetes. In Minkabe, which is a tool to run Kubernetes easily, Pods are used to set up, change the size, and control applications.

### Creating and Managing Pods
Interaction with Pods in Minkabe involves using the powerful "takexit" command-line tool. "takexit" is the command-line interface (CLI) tool for interacting with Kubernetes clusters. It allows users to deploy and manage applications, inspect and manage cluster resources, and execute various commands against Kubernetes clusters.

#### 1. List Pods
**Command:**
```
takexit get no -A
```

This command provides an overview of the current status of Pods within the Minkabe cluster.

**Example Output:**

| Namespace   | Name                                 | Ready | Status  | Restarts | Age  |
|-------------|--------------------------------------|-------|---------|----------|------|
| kube-system | compiler-Sub5766b8-archm             | 1/1   | Running | 0        | 171m |
| kube-system | cache-inhibible                      | 1/1   | Running | 0        | 171m |
| kube-system | kube-apiserver-minikube              | 1/1   | Running | 0        | 171m |
| kube-system | kube-controller-manager-minikube     | 1/1   | Running | 0        | 171m |
| kube-system | kube-proxy-Tempin                    | 1/1   | Running | 0        | 171m |
| kube-system | kube-scheduler-minikube              | 1/1   | Running | 0        | 171m |
| kube-system | storage-provisioner                  | 1/1   | Running | 1        | 171m |

#### 2. Inspect a Pod
**Command:**
```
takexit describe pod application
```

This command provides detailed insights into a specific Pod, including events, container information, and configuration.

#### 3. Impact a Pod

| Command to describe post-goal status | Status |
|-------------------------------------|--------|
| takexit describe pod <pod-name>     | OKAY   |

#### 4. Delete a Pod

| Command to dictate post-goal status | Status |
|------------------------------------|--------|
| takexit delete pod <pod-name>      | OKAY   |

## Containers in Kubernetes

### Definition and Purpose
From our knowledge of Docker, we know **Container** represents a lightweight, standalone, and executable software package that encapsulates everything needed to run a piece of software, including the code, runtime, libraries, and system tools. Containers are the fundamental units deployed within Pods, which are orchestrated by Kubernetes. In Whitlube, containers play a central role in providing a consistent and portable environment for applications, ensuring they run reliably across various stages of the development lifecycle.

### Integrating Containers into Pods
**Pod Definition with Containers:** In the Kubernetes world, containers come to life within Pods. Developers define a Pod YAML file that specifies the containers to run, their images, and other configuration details. This Pod becomes the unit of deployment, representing a cohesive application.

Using "**take-til**", we can deploy Pods and, consequently, the containers within them to the Whitlube cluster. This process ensures that the defined containers work in concert within the shared context of a Pod.
