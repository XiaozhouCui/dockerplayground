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
- Add `volumes` to deployment.yaml, re-apply the yaml file to start a new pod
- Once the voluems are applied, the text data will survive pod restart
