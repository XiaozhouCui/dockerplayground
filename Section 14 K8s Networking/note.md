## Prepare for k8s first deployment: users-api
- Make sure that the demo app is working locally by running `docker-compose up -d --build`
- Test by posting dummy login (`"email": "test@test.com", password:"tester"`) request to `localhost:8080/login`
- Close the local docker containers by running `docker-compose down -v`
- In user-app.js, replace all the axios request with dummy data (`http://auth/...` won't work on k8s)
- On Docker Hub, create a new repo `xiaozhoucui/kub-demo-users`
- Goto `users-api` subfolder, build image `docker build -t xiaozhoucui/kub-demo-users .`, then push to docker hub
- Create a new folder `kubernetes`, and a new file `users-deployment.yaml` inside that folder
- Inside yaml file, define the pod for app `users` using the newly built image
- Goto kubernetes folder and run `kubectl apply -f users-deployment.yaml` to start the pod

## Add a k8s service
- In kubernentes folder, add a new file `users-service.yaml`, name the service `users-service`, select app `users`
- Apply the service `kubectl apply -f users-service.yaml`
- Use minikube to run the service `minikube service users-service`, then use the URL in Postman

## Pod-internal communication
- users-api and auth-api are in the same pod (same deployment)
- In local machine docker-compose, service name `auth` is used in URL `http://auth/...`
- In docker-compose.yaml, add environment `AUTH_ADDRESS: auth`
- In k8s, an environment variable `process.env.AUTH_ADDRESS` is used in URL to replace `auth`
- To make a running auth-api, create a docker hub repo `xiaozhoucui/kub-demo-auth` goto auth-api/ folder, build image and push to docker hub
- To make sure user-api and auth-api are in one pod, go to users-deployment.yaml and add **a second container** `auth`. 
- Don't add auth to the service.yaml because auth-api is pod-internal, no need to expose port for auth-api
- Goto users-api folder, rebuild image and push to `xiaozhoucui/kub-demo-users`
- In k8s, `localhost` can be used when the containers are in the same pod
- In users-deployment.yaml, add env `AUTH_ADDRESS: localhost`
- Goto kubernetes folder and apply the updated yaml `kubectl apply -f users-deployment.yaml`
- Now there will be **2** containers running in the same pod: users-api and auth-api
- In Postman, send POST request to `http://127.0.0.1:*****/signup` it should respond `User created!`
