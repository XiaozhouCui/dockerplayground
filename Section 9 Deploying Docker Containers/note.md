# Single container deployment
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

# Multi container deployment
## Push goals-node to Docker Hub
- On AWS, delete service and delete cluster, this will take a couple of minutes
- On ECS, the service name `mongodb` no longer work as part of the db connection string.
- If all containers are deployed in the same task, then `localhost` can be used.
- In Dockerfile, add `ENV MONGODB_URL=mongodb`
- Build the backend image `docker build -t goals-node ./backend`
- Create a new repo on Docker Hub `xiaozhoucui/goals-node`
- Re-tag image `docker tag goals-node xiaozhoucui/goals-node`
- Push to Docker Hub `docker push xiaozhoucui/goals-node`

## Create new ECS task
- On ECS, click "Create New Claster", then select "Networking only", then click "Next" to configure cluster
- Enter cluster name `goals-app`, check `Create VPC` box and keep default settings `1.0.0.0.16` and 2 subnets `10.0.1.0/24` and `10.0.0.0/24`, then click "Create"
- Once created, go to task definitions and click "Create new task". Choose `FARGATE` then click "Next"
- In config screen, enter `goals` as task definition name, and select "ecsTaskExecutionRole" as task role
- In task size options, choose smallest `0.5GB` memory and `0.25vCPU`, then click "Add container"

## Add first container: goals-backend
- In container screen, enter container name `goals-backend`, enter image repo `xiaozhoucui/goals-node`, on Port mappings enter `80`
- Under ENVIRONMENT header, enter `node,app.js` as Command, enter environment variables as per backend.env, but add `MONGODB_URL=localhost`
- Under STORAGE AND LOGGING header, no need to add volume and bind mounts, click "Add" to add container 

## Add second container: mongodb
- Click "Add container" again, then enter name `mongodb`, in "Image" just enter `mongo` the default image, on Port mappings enter `27017`
- Under ENVIRONMENT header, enter environment variables as per mongo.env
- Under STORAGE AND LOGGING header, volume will be added to persist data
- Click "Add" to add container, and go back to the task config screen, then click "Create"

## Add Service to the task
- Once the task is created, go to goals-app cluster, under "Services" tab click "Create"
- In Config service, choose `FARGATE`, in "Task Definition" drop down, choose `goals`, in "Service name" enter `goals-service`, in "Number of tasks" enter `1`, keep other settings and click "Next step"
- In Config network, select `vpc-...(10.0.0.0/16)`, in Subnets select both 2 subnets (`10.0.1.0/24` and `10.0.0.0/24`), make sure "Auto-assign public IP" is `ENABLED`
- Under Load balancing, choose `Application Load Balancer`
- Before proceeding, need to create a load balancer first. Click the link "Please create a load balancer in the EC2 Console" to open the "Select load balancer type" page
- Under "Application Load Balancer" click "Create" to open "Configure Load Balancer" page
- In "Name" field enter `ecs-lb`, use Port `80`, connect to the save VPC `vpc-...(10.0.0.0/16)`, then check the 2 availability zones. Click "Next" and "Next" again to the Security Groups page
- Select `Select an existing security group` and tick the default group ID. Click "Next" to config routing
- Enter `tg` as target group name, select `IP` as "Target type". Click "Next" to register targets
- EC2 will automatically configure the register targets, click "Next" and then click "Create"
- Once LB is created, go back to Create Service window, and select `ecs-lb` as "Load balancer name"
- Select container `goals-backend:80:80` and click "Add to load balancer". 
- Select `tg` as targe group, click "Next" then click "Next" again then click "Create service"
- Now go to Cluster -> goals-app -> tasks, we can see the tasks are linked to the created service.

## Load Balancer setup
- Go to EC2 -> Load Balancer, copy the "DNS name" to access the API
- Add `goals--***` to the security group of Load Balancer
- In EC2 -> Target Groups -> tg, click "Edit" and add enter `/goals` to "**Health check path**", otherwise the task will frequently stop due to failed health check (too many 404 responses to root url `/`)

## Push updated code to ECS
- Make change to source code and rebuild image, push image to Docker Hub
- On ECS, go to Cluster -> Services -> goals-service and click "Update" button
- On Configure Service screen, tick `Force new deployment` box and Update Service.
- The task will restart, starting a new container and removing the old one.
- Once restarted, all database data will be lost. Need to add a `volume`

## Add volume
- Go to Task Definitions -> goals -> goals:1 then click "**Create new revision**"
- Click "Add volume" button at the bottom to open modal
- Enter `data` as Name, select `EFS` (Elastic File System) as Volume type, 
- Open a new window for EFS and click "Create file system" to open modal
- Enter `db-storage` as Name, and select `vpc-...` as Virtual Private Cloud, then click "**Customize**"
- Before customizing EFS, go to EC2 -> Security Group -> Create Security Group
- Name it `efs-sc`, add description `Security group for EFS`, select `vpc-...`, click "Add inbound rule"
- Choose `NFS` as Type, and select container's `sg-...` as incoming security group, via port `2049`
- Click "Create security group" button and then the containers can talk to EFS via port `2049`
- Go back to EFS customize screen, click "Next" goto "Network access", 
- Select VPC `vpc-...`, Add the newly created security group `efs-sc` to both zones, click "**Next**" then "**Create**"
- EFS created, then go back to "Add volume" page and select `db-storage` as File system ID, click "Add"

## Connect volume to mongodb container
- Go to mongodb container modal, goto "STORAGE AND LOGGING" header
- Select `data` volume and enter container path `/data/db` to bind it. Click "Update", then click "Create"

## Update Service to redeploy
- New revision created, then select "Update Service" under "Action" 
- Check `Force new deployment` box, select `1.4.0` as Platform version, then click "Update Service"
- Then all the data will be persisted

# Moving to MongoDB Atlas

## Update backend app
- In Dockerfile and backend.env add new ENV `MONGODB_NAME=goals-dev`, to switch db between dev and prod
- In docker-compose.yaml, remove the mongodb service and volume, because it is no longer containerised.
- In backend.env, replace the username and password with Atlas login details
- In app.js, update the connection string to link to Atlas
- Rebuild the image and push to Docker Hub

## Create a new task revision on ECS
- In EFS, delete the `db-storage`. In EC2, delete the security group `efs-sc`
- In ECS, go to latest goals task, click **Create new revision**
- Delete the `mongodb` container by clicking the `x` on the right. Delete the `volume`
- Click `goals-backend` to open modal, update the ENV, including `MONGODB_NAME=goals`, click **Update**
- Click **Create** new revision. In **Actions** dropdown, select **Update Service**
- Check `Force new deployment` box and skip to **Update Service**
- Now `goals-backend` container is connected to Atlas

# Add container for React SPA

## Create a "build-only" container
- Frontend don't need dev server in production, so create a new docker file `Dockerfile.prod`