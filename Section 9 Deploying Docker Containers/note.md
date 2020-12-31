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
