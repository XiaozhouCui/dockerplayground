# Kubernetes Basics
## Kubernetes introduction
- **Kubernetes** is like Docker-Compose for *multiple machines* for deployment
- **Pod (Container)**: the smallest unit in Kubernetes, it holds the actual running App Containers and their resources (e.g. volumes). Multiple pods can be created or removed to scale the App
- **Services**: A logical set of pods with a unique, pod-independent and container-independent IP address
- **Worker Node**: a virtual machine/instance (with certain amount of CPU and memory) that runs the pods/containers
- **Proxy/Config**: inside a worker node, controls the network traffic on its worker node
- **Kubelet**: inside a worker node, communicate between Master and Worker Node
- **Master Node and Control Plane**: a special virtual machine/instance that interacts with all worker nodes and controls the deployment
- **Cluster**: A network of machines containing all Master + Worker Nodes; it sends instructions to cloud provider API

## What Kubernetes can do
- Create objects (pods) and manage them, auto distribute them
- Monitor pods and recreate them, restart them if they fail, scale pods
- Utilise the provided (cloud) resources to apply your configurations

# Install Kubernetes
## Install Chocolatey
- Open Power-Shell as admin
- Run `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

## Install kubectl
- Open Power-Shell or CMD as admin
- Run `choco install kubernetes-cli`
- To chekc if it's installed, run `kubectl version --client`

## Setup user folder
- In CMD, run `cd %USERPROFILE%` to goto the user folder
- Run `mkdir .kube` to create a new folder named `.kube`
- Goto the `.kube` folder and create a new file `config`, NO EXT.
- This `config` file will tell the **kubectl** command to which Cluster it should connect. It'll be auto populated

## Install Minikube
<!-- - First need to download the **VirtualBox** installer for Windows and install it
- VirtualBox will be the driver for Minikube -->
- Open Power-Shell or CMD as admin
- Run `choco install minikube` to install **Minikube**
- Once installed, run `minikube start --driver=docker` to start minikube on **Docker**
- This will create a virtual machine which will host the development **Cluster**, setting up everything inside
- kubectl is now configured to use "minikube" cluster and "default" namespace by default
- Run `minikube dashboard` will open a dashboard in browser