## Connect to EC2 instance
- Build image from dockerfile and start container, no Bind Mounts in production
- On AWS, start a new EC2 instance, (Linux AMI t2.micro), create and download key-pair "example-1.pem"
- To connect to EC2 instance with SSH, need to install Putty on Windows.
- Use PuTTY Gen to convert "example-1.pem" to "example.ppk"
- Open PuTTY, load "example.ppk" in Auth, enter the connection string in Session, then click "Open"

## Install Docker on EC2
- In PuTTY terminal, enter `sudo yum update -y` to pudate required packages
- To install docker, enter `sudo amazon-linux-extras install docker`
- Once the installation is finished, run `sudo service docker start` to start docker service
- After docker service is started, `docker run` can be used.

## Push local image to the cloud
- Go to Docker Hub and create a repository "node-example-1"
- Before pushing, add a .dockerignore file to exclude node_modules, *.ppk and *.pem
- Rebuild the image `docker build -t node-dep-example-1 .`
- Rename the image `docker tag node-dep-example-1 xiaozhoucui/node-example-1`
- Run `docker login` to login to docker hub
- Run `docker push xiaozhoucui/node-example-1`

## Run and publish the app on EC2 instance
- In PuTTY, enter `sudo docker run -d --rm -p 80:80 xiaozhoucui/node-example-1`
- The container is running on the EC2 instance, without installing Node.js
- In AWS console, go to security group of EC2 instance, add a new inbound rule "HTTP from anywhere"
- Now the Node app is accessable from the public IP address

## Push update to the cloud
- Update the local html file
- Rebuild the image `docker build -t node-dep-example-1 .`
- Update the tag `docker tag node-dep-example-1 xiaozhoucui/node-example-1`
- Push image to Docker Hub `docker push xiaozhoucui/node-example-1`
- On PuTTY, stop the current container `sudo docker stop ...`
- Force update the local image on EC2 `sudo docker pull xiaozhoucui/node-example-1`
- Restart the container `sudo docker run -d --rm -p 80:80 xiaozhoucui/node-example-1`

## Close the EC2 instance
- On PuTTY, stop the current container `sudo docker stop ...` and then enter `exit`.
- On AWS console, terminate the EC2 instance.

## Deploy on AWS ECS
- AWS console -> ECS -> Get Started -> Configure custom container
- In repo enter `xiaozhoucui/node-example-1`
- "Advanced container configuration" can set up WORKDIR, CMD and environment variables etc.
- Once the Container and Task are defined, click "Next" to go to Service, Load Balancer can be added here
- Click "Next" then go to Cluster, multiple containers can be setup here.
- Click "Next" to view summary, then click "Create"
- Once created, go to the task details page, then use the Public IP to access the deployed node app in browser

## Update code on ECS
- Change the html file on local machine
- Rebuild the image `docker build -t xiaozhoucui/node-example-1 .`
- Push to Docker Hub `docker push xiaozhoucui/node-example-1`
- On AWS, go to task definition page, click "Create New Revision"
- Keep all the settings and click "Create"
- After a new revision is created, Select "Update Service" from actions dropdown.
- Keep all settings, "Skip to review" and then click "Update Service", this will pull latest image and restart the task.
- Once the new task is created, the old task (including IP address) will be deleted automatically.

## Multi container deployment
- On AWS, delete service and delete cluster, this will take a couple of minutes
- On ECS, the service names no longer work as part of the db connection string.
- If all containers are deployed in the same task, then `localhost` can be used.
- In Dockerfile, add `ENV MONGODB_URL=mongodb`
- Build the backend image `docker build -t goals-node ./backend`
- Create a new repo on Docker Hub `xiaozhoucui/goals-node`
- Re-tag image `docker tag goals-node xiaozhoucui/goals-node`
- Push to Docker Hub `docker push xiaozhoucui/goals-node`

## Create new ECS task
- On ECS, click "Create New Claster", then select "Networking only", then click "Next" to configure cluster
- Enter cluster name "goals-app", check "Create VPC" and keep default settings, then click "Create"
- Once created, go to task definitions and click "Create new task". Choose "FARGATE" then click "Next"
- In config screen, enter `goals` as task definition name, and select "ecsTaskExecutionRole" as task role
- In task size options, choose smallest `0.5GB` memory and `0.25vCPU`, then click "Add container"

## Add first container: goals-backend
- In container screen, enter container name `goals-backend`, enter image repo `xiaozhoucui/goals-node`, on Port mappings enter `80`
- Under ENVIRONMENT header, enter `node,app.js` as Command, enter environment variables as per backend.env, but add `MONGODB_URL=localhost`
- Under STORAGE AND LOGGING header, no need to add volumne and bind mounts, click "Add" to add container. 

## Add second container: 