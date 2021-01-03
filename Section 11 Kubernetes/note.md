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
