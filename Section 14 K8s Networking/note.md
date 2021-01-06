## Prepare for k8s first deployment: user-api
- Make sure that the demo app is working locally by running `docker-compose up -d --build`
- Test by posting dummy login (`"email": "test@test.com", password:"tester"`) request to `localhost:8080/login`
- Close the local docker containers by running `docker-compose down -v`
- In user-app.js, replace all the axios request with dummy data (`http://auth/...` won't work on k8s)
- On Docker Hub, create a new repo `xiaozhoucui/kub-demo-users`
- Goto `user-api` subfolder, build image `docker build -t xiaozhoucui/kub-demo-users .`, then push to docker hub
- Create a new folder `kubernetes`, and a new file `users-deployment.yaml` inside that folder
- Inside yaml file, define the pod for app `users` using the newly built image
- Goto kubernetes folder and run `kubectl apply -f users-deployment.yaml` to start the pod
