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
