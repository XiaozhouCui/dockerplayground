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

## Pod-internal communication: users-api and auth-api
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
- In Postman, send POST request to `http://127.0.0.1:*****/signup` it should respond `User created!`, meaning 2 containers inside 1 pod can talk to each other successfully

## Use IP Address for Pod-to-Pod communication
- Move auth-api into a separate pod, so the users-api and auth-api no longer run in same pod
- Create a new yaml file `auth-deployment.yaml`, name the pod `auth`
- Remove the auth container from `users-deployment.yaml`
- Add a `auth-service.yaml`, selector point to app `auth`
- Since the auth-api is not exposed to the outside world, use service type `ClusterIP`
- Run `kubectl apply -f auth-service.yaml -f auth-deployment.yaml` to start the service
- Use `kubectl get service` to get the IP address for the auth-service, use this IP address `"10.107.88.2"` to replace the env `localhost` inside users-deployment.yaml.
- Apply the updated yaml file `kubectl apply -f users-deployment.yaml`, there will be 2 pods running, each containing 1 container. Post requests should still work for /login and /signup

## Use environment variables for Pod-to-Pod communication
- To avoid using hard-coded IP address in yaml files, use the K8s **auto generated** env variables to replace `process.env.AUTH_ADDRESS`
- In K8s, the IP address for service `auth-service` is stored in variable `AUTH_SERVICE_SERVICE_HOST`
- In K8s, the IP address for service `users-service` is stored in variable `USERS_SERVICE_SERVICE_HOST`
- In users-app.js, replace all the env `process.env.AUTH_ADDRESS` with `process.env.AUTH_SERVICE_SERVICE_HOST`
- In docker-compose.yaml, add environment `AUTH_SERVICE_SERVICE_HOST: auth`
- Goto users-api folder and rebuild image, push to docker hub
- Go back to kuberetes folder, delete the running deployment `kubectl delete -f users-deployment.yaml`
- Reapply the yaml file `kubectl apply -f users-deployment.yaml`, Post requests shouls still work
- Note that env `AUTH_ADDRESS: "10.107.88.2"` in yaml file is no longer used

## Use internal domain name (Recommended) for Pod-to-Pod communication
- Instead of IP or env, we can use K8s (CoreDNS) **auto generated** internal domain name to refer to a service
- In the signup URL in users-app.js, change the env back to `AUTH_ADDRESS`, repush to docker hub
- In users-deployment.yaml, update the env `AUTH_ADDRESS: "auth-service.default"`, *service-name.name-space*
- Re-apply the yaml file `kubectl apply -f users-deployment.yaml` 
- Post requests should still work for /signup

## Communication from tasks-api to auth-api
- In tasks-app.js, replace the `auth` in request URL with `process.env.AUTH_ADDRESS`
- In docker-compose.yaml, add `AUTH_ADDRESS: auth` under env of `tasks` service
- Create `tasks-deployment.yaml` and `tasks-service.yaml`
- On docker hub, create `xiaozhoucui/kub-demo-tasks`
- Goto tasks-api/ folder, build image `docker build -t xiaozhoucui/kub-demo-tasks .`, push to docker hub
- Goto kubernetes/ folder, apply tasks resources `kubectl apply -f tasks-service.yaml -f tasks-deployment.yaml`
- To start the tasks service, run `minikube service tasks-service`
- Send POST request `{"text": "asdf", "title": "asdf"}` to new URL `http://localahost:*****/tasks`, with auth header `Authorization: Bearer abc`, the tasks should be stored. Send GET req to the same url to fetch tasks
- Now the tasks-api can talk to internal auth-api via `AUTH_ADDRESS: "auth-service.default"`

## Adding a containerised Frontend
- Make sure `CORS` headers are added in tasks-app.js, to allow browser requests
- The frontend dockerfile can build a multi-stage image for production build
- In frontend App.js, replace the fetch URL with `http://localahost:*****/tasks` from minikube service
- Goto frontend/ folder, run `docker build -t xiaozhoucui/kub-demo-frontend .`
- Use **docker** to start container `docker run --rm -d d-p 80:80 xiaozhoucui/kub-demo-frontend`
- Open browser, goto `localhost` should load the app, post and fetch tasks
- Run `docker stop ***` to stop and remove the container