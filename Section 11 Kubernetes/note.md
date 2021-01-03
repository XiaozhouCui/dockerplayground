## Kubernetes introduction
- **Kubernetes** is like Docker-Compose for *multiple machines* for deployment
- **Pod (Container)**: the smallest possible unit in Kubernetes, multiple pods can be created or removed to scale your app
- **Worker Node**: a virtual machine/instance (with certain amount of CPU and memory) that runs the pods/containers
- **Proxy/Config**: inside a worker node, controls the network traffic on its worker node
- **Master Node and Control Plane**: interacts with all worker nodes and controls the deployment
- **Cluster**: contains all Master + Worker Nodes; sends instructions to cloud provider API

## What Kubernetes can do
- Create objects (pods) and manage them, auto distribute them
- Monitor pods and recreate them, restart them if they fail, scale pods
- Utilise the provided (cloud) resources to apply your configurations
