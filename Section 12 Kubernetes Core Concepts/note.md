## The Pod Object
- Containes and runs one or multiple containers
- Pots contain shared resources (e.g. volumes)
- Has a cluster-internal IP by default
- Pods are designed to be **ephemeral** (short-lived)

## Deployment Object
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

## Service Object
- Service can allow external access to pods
- To create a service on port `8080`, run `kubectl expose deployment first-app --port=8080 --type=LoadBalancer`
- To check the created service, run `kubectl get services`
- To access the service from local machine, run `minikube service first-app` to open node app on browser
- On browser, goto `/error` to crash the app, then the pod will restart

## Scaling
- To create multiple instances pods/containers, run `kubectl scale deployment/first-app --replicas=3`
- There will be 3 pods running, run `kubectl get pods` to find out
- Load Balancer will dirtribute traffic evenly to these 3 pods. If one pod crashes, others will keep working
- To scale down, run `kubectl scale deployment/first-app --replicas=1`

## Updating deployments (source code)
- Update the source code in *app.js*
- Rebuild the image **with a new tag ":2"** `docker build -t xiaozhoucui/kub-first-app:2 .`
- Push image to docker hub `docker push xiaozhoucui/kub-first-app:2`
- To update k8s image, run `kubectl set image deployment/first-app kub-first-app=xiaozhoucui/kub-first-app:2`
- To update deployment, run `kubectl rollout status deployment/first-app`
- A new pod will be up and running, the old pod will be removed. New content can be access via browser

## Deployment Rollbacks and History
- Intentionally make a mistake, pulling an image that doesn't exist. `kubectl set image deployment/first-app kub-first-app=xiaozhoucui/kub-first-app:3`
- Rollout the faulty image `kubectl rollout status deployment/first-app`
- Old pod will not terminate until the new pod is up and running, so the node app still works
- Run `kubectl get pods` to find the failed pod with status `ImagePullBackOff`
- To **un-do** the latest deployment, run `kubectl rollout undo deployment/first-app`
- Once rolled back, the faile pod will be removed
- To list the rollout history of a deployment, run `kubectl rollout history deployment/first-app`
- To find the image of a certain revision, run `kubectl rollout history deployment/first-app --revision=3`
- To rollback to a sepcific revision, run `kubectl rollout undo deployment/first-app --to-revision=1`

## Delete the service and deployment
- Run `kubectl delete service first-app` to delete service
- Run `kubectl delete deployment first-app` to delete deployment

## Deployment Configuration File
- Create a new file `deployment.yaml`, name the deployment `second-app-deployment`
- Inside the yaml file, create a minimal deployment with one pod using one image
- Run `kubectl apply -f="deployment.yaml"`
- This attemp will fail because the field **slelector** is missing in yaml file
- Add `selector` and match the labels in `template`
- Run `kubectl apply -f deployment.yaml` it should work
- Run `kubectl get deployments` will find the `second-app-deployment` up and running

## Service yaml file
- Create a new file `service.yaml`, name the service `backend`
- Inside the yaml file, choose which pods will be part of this service
- Run `kubectl apply -f service.yaml`
- Run `kubectl get services` will see the `backend` juse created
- To expose the service, run `minikube service backend`, node app will show up in browser
- The declarative method (yaml file) is more popular than commands, which are easy to miss args

## Update and delete resources
- To scale up or down, simply update yaml file `replicas: 3`, then apply `kubectl apply -f deployment.yaml`
- To change image, update `image: xiaozhoucui/kub-first-app`, then apply `kubectl apply -f deployment.yaml`
- To delete the resources created by yaml files, run `kubectl delete -f deployment.yaml -f service.yaml`

## Single config file
- Create a new file `all-in-one.yaml`, copy the content from other yaml files and separate with `---`
- Make sure the `service` object is in front of `deployment` object
- Run `kubectl apply -f all-in-one.yaml` to create both objects

## Labels and selectors
- Add label `group: example` to both service and deployment yaml file
- Start the deployment and service `kubectl apply -f deployment.yaml -f service.yaml`
- Can select resources by label (`group: exmaple`), not only by name (`second-app-deployment`)
- To delete resource by label (group), run `kubectl delete deployments,services -l group=example`