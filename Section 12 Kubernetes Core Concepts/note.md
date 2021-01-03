## The Pod Object
- Containes and runs one or multiple containers
- Pots contain shared resources (e.g. volumes)
- Has a cluster-internal IP by default
- Pods are designed to be **ephemeral** (short-lived)

## Deployment object
- You set a desired state, then K8s changes the actual state, defin which pods to run and number of instances
- Deployments acan be paused, deleted and rolled back
- Deployments can be scaled dynamically, when metrics (incoming trafic, CPU etc.) are exceeded, k8s create more pods

## First Deployment Object
- 