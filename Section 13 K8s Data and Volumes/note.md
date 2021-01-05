## Start the project on local cluster
- Prepare the yaml files for deployment and service
- Build image and push to docker hub `xiaozhoucui/kub-data-demo`
- Apply the yaml files `kubectl apply -f service.yaml -f deployment.yaml`
- To get the URL running node app, run `minikube service story-service` 

## K8s volumes
- Volume is part of a pod
- Update app.js, build image and push to docker hub `xiaozhoucui/kub-data-demo:1`
- Re-apply the deployment yaml file, new pod will be created, POST a new text
- Goto `http://localhost:*****/error` to crash the app, pod will restart, but the saved text is gone
- Add `volumes` and use type `emptyDir` in deployment.yaml, re-apply the yaml file to start a new pod
- Once the voluems are applied, the text data will survive pod restart

## A Second Volume, the "hostPath" type
- If there are more than 1 `replicas`, volume will not work before the pod restarts due to error.
- `hostPath` will make multiple pods share one path on the host machine
- In deployment.yaml, update `replicas: 2`, replace the `emptyDir` with `hostPath`
- Re-apply `kubectl apply -f deployment.yaml`, the text data can still be fetched when 1 pod is down
- Downside: hostPath can only work for pods inside **One Node**

## Persistent Volume and Persistent Volume Claim
- Persistent volumes are inside cluster but are independent of Nodes
- Create a persistent volume yaml file **host-pv.yaml**
- To use the persistent volume inside a cluster, pod need to make a **Claim**
- Create a persistent volume *claim* yaml file **host-pvc.yaml**
- To connect a pod to a *claim*, use volume type `persistentVolumeClaim` in deployment.yaml
- To use a Claim in a Pod, first run `kubectl apply -f host-pv.yaml`, then run `kubectl apply -f host-pvc.yaml`
- Persistent volumes and claims can be seen by running `kubectl get pv` and `kubectl get pvc`
- Apply the deployment `kubectl apply -f deployment.yaml` to use the persistent volume `host-pv` as pod's volume

## Environment Variables
- In app.js, replace `story` folder with `process.env.STORY_FOLDER`
- In deployment.yaml add `env`, then add key-value pairs under `env`
- Rebuild the image, upload to docker hub, reapply deployment.yaml, the app will work as before
- Environment variables can be extracted into a **ConfigMap** yaml file `environment.yaml`
- Name configMap `data-store-env`, add `folder: "story"`, then apply it `kubectl apply -f environment.yaml`
- To check the config maps, run `kubectl get configmap`
- In deployment.yaml, replace `value` with `valueFrom`