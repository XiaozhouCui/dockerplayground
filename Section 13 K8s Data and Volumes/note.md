## Start the project on local cluster
- Prepare the yaml files for deployment and service
- Build image and push to docker hub `xiaozhoucui/kub-data-demo`
- Apply the yaml files `kubectl apply -f service.yaml -f deployment.yaml`
- To get the URL running node app, run `minikube service story-service` 