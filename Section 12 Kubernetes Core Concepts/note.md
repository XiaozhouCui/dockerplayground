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
- Run `minikube status` to check if k8s cluster is running, if not, run `minikube start --driver-docker`
- Build node app image with dockerfile `docker build -t kub-first-app .`
- Run `kubectl help` to brows all commands
- Create a **deployment object**, run `kubectl create deployment first-app --image=kub-first-app`
- Run `kubectl get deployments` to see all the deployments, `kubectl get deployments` to see all pods
- Pods shows `ErrImagePull` because K8s can't read image on local machine
- Delete the failed deployments `kubectl delete deployment first-app`
- K8s need to pull image from Docker Hub. Goto Docker Hub and create a repo `xiaozhoucui/kub-first-app`
- Retag the local image `docker tag kub-first-app xiaozhoucui/kub-first-app`
- Push the image to Docker Hub `docker push xiaozhoucui/kub-first-app`
- Run `kubectl create deployment first-app --image=xiaozhoucui/kub-first-app` to pull image from docker hub
- After a while, the deployment will be created. Check it with `kubectl get deployments` and `kubectl get pods`
- Run `minikube dashboard` to open the dashboard in browser, deployments and pods can be inspected here
