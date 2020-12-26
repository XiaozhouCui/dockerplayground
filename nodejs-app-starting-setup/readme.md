## "docker run" and "docker start"

- `docker run -p 3000:80 CONTAINER` will automatically attach to the running container, unless `-d` is added.
- `docker start CONTAINER` will re-start a container without attaching to its console.
- To check the logs in a detached container, run `docker logs CONTAINER`
- To keep listening to a detached container, run `docker logs -f CONTAINER`

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
- Run `docker run -p 3000:80 -d --rm --name goalsapp goals:latest` to starat a new container "goalsapp" based on image "goals:latest"