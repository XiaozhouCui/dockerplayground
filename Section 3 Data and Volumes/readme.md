## Add ANOMYOUS volumes to containers
- To add anonymous volumes, add `VOLUME [ "/app/feedback" ]` in Dockerfile
- Then create an image with `docker build` and start a container with `docker run` as usual
- "/app/feedback" is the specified path inside container
- Docker sets up a folder/path on your host machine, exact location is unknown to you
- Run `docker volume ls` to list all volumes 
- Anonymous volumes will NOT survive container shutdown

## Add NAMED volumes to containers
- Remove the anonymous volume `VOLUME [ "/app/feedback" ]` from Dockerfile
- Build the image as usual, run `docker build -t feedback-node:volumes .`
- When building the container, use option `-v` to add a named volume "feedback"
- Run `docker run -d --rm -p 3000:80 --name feedback-app -v feedback:/app/feedback feedback-node:volumes`
- Named volume "feedback" will be mapped to "/app/feedback" inside container
- Named volume "feedback" can be found via command `docker volume ls`.
- Named volumes are not attached to containers, and will survive container shutdown
- To re-connect a named volume, add `-v feedback:/app/feedback` when starting a new container

## Bind Mounts: instant update, no rebuild
- You specify the folder on your host machine where the volume is bound to.
- When starting a new container, add a SECOND `-v` option, and the ABSOLUTE PATH of your local current folder `"%cd%"`
- `-v "%cd%":/app` will overwrite entire "/app" folder in container with current local folder
- Then add a THIRD `-v` option, to add an anonymous volume for /app/node_modules folder inside container
- `-v /app/node_modules` will make sure the "/app/node_modules" inside container is NOT over written, and will also create an empty "node_modules" folder in local current folder
- In Windows cmd (not power-shell), run `docker run -d --rm -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "%cd%":/app -v /app/node_modules feedback-node:volumes`

## Read-only volumes
- Add `:ro` at the end of the bind mount volume
- Add another `-v` option with "/app/temp" after the bind mount volume to over write it.
- Run `docker run -d --rm -p 3000:80 --name feedback-app -v feedback:/app/feedback -v "%cd%":/app:ro -v /app/temp -v /app/node_modules feedback-node:volumes`
