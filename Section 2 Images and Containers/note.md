## Create images
- Build a Dockerfile in the project folder
- Run `docker build .` to create an anonymous image, docker will auto assign name and ID to it
- Every instruction in Dockerfile creates a cacheable layer
- Images are read-only, re-build is required in order to change anything in an image.

## Start a container
- Once an image is created, use `docker run` to start a container
- For web server type containers, run `docker run -p 3000:80 IMAGE` to publish and listen to port 3000
- For interactive type containers, run `docker run -it IMAGE` to enable terminal and input

## "docker run" and "docker start"

- `docker run -p 3000:80 IMAGE` will automatically attach to the running container, unless `-d` is added.
- `docker start CONTAINER` will re-start a container without attaching to its console.
- To check the logs in a detached container, run `docker logs CONTAINER`
- To keep listening to a detached container, run `docker logs -f CONTAINER`

## Interactive Mode (need input on terminal)

- When terminal input is needed, `docker run IMAGE` will show error   
- To enter input into container, need to use `docker run -it IMAGE` to start interactive mode and a terminal
- When using `docker start CONTAINER` to re-start a container, `-a` can attach, but cannot enter value.
- Use `docker start -a -i CONTAINER` to interact with container.

## Remove containers and images

- Run `docker ps -a` to check all containers.
- Running container cannot be removed until it is stopped.
- Run `docker rm CONTAINER` to remove a single container.
- Run `docker rm CONTAINER1 CONTAINER2 CONTAINER3 ...` to remove multiple containers.
- Run `docker container prune` to remove all stopped containers at once.
- Run `docker images` to check all images.
- Run `docker rmi IMAGE` to remove an image.
- Run `docker image prune -a` to remove all images including tagged images.

## Auto remove stopped containers

- Add `--rm` when using `docker run` command
- Example: `docker run -p 3000:80 -d --rm IMAGE`

## Copy file into and from a running container

- Copy file from local folder into container: `docker cp dummy/test.txt CONTAINER:/test`.
- Copy file from container to local folder: `docker cp CONTAINER:/test/test.txt dummy`.

## Name a container
- Use `--name` to name the container as "goalsapp"
- Run `docker run -p 3000:80 -d --rm --name goalsapp IMAGE`

## Add "name:tag" combination to an image
- Use `-t` to add "name:tag" to an image, for example: "node:12" where tag 12 is optional
- Run `docker build -t goals:latest .` to create a new image "goals:latest" based on current Dockerfile
- Run `docker run -p 3000:80 -d --rm --name goalsapp goals:latest` to starat a server container "goalsapp" based on image "goals:latest"
- Run `docker run --rm -it --name bmiapp bmi:initial` to starat an interactive container "bmiapp" based on image "bmi:initial"

## Share images on docker hub
- First need to create a repository on docker hub "xiaozhoucui/node-hello-world"
- Rename an existing image on local machine, use `docker tag` command 
- Run `docker tag node-demo:latest xiaozhoucui/node-hello-world` to rename "node-demo:latest" to "xiaozhoucui/node-hello-world:latest"
- Before pushoing the image, need to run `docker login` to connect the local machine to docker hub
- Run `docker push xiaozhoucui/node-hello-world` to push image to docker hub
- Not the whole image will be pushed to docker hub, because repo "node:latest" already exists on the cloud

## Pull images from docker hub
- Images can be pulled without login. To prove it, run `docker logout` before pulling
- Run `docker pull xiaozhoucui/node-hello-world`
- `docker pull` will automatically pull the "latest" version on docker hub
- Wether pulled or not, we can run it directly `docker run -p 5000:3000 --rm -d xiaozhoucui/node-hello-world`
- If no local image called "xiaozhoucui/node-hello-world" found, docker will search for docker hub and pull it.
