## Add ANOMYOUS volume to a container
- To add anonymous volumes, add `VOLUME [ "/app/feedback" ]` in Dockerfile
- Then create an image with `docker build` and start a container with `docker run` as usual
- "/app/feedback" is the specified path inside container
- Docker sets up a folder/path on your host machine, exact location is unknown to you
- Run `docker volume ls` to list all volumes 
- Anonymous volumes will NOT survive container shutdown

## Add NAMED volume to a container
- Remove the anonymous volume `VOLUME [ "/app/feedback" ]` from Dockerfile
- Build the image as usual, run `docker build -t feedback-node:volumes .`
- When building the container, use option `-v` to add a named volume "feedback"
- Run `docker run -d --rm -p 3000:80 --name feedback-app -v feedback:/app/feedback feedback-node:volumes`
- Named volume "feedback" will be mapped to "/app/feedback" inside container
- Named volume "feedback" can be found via command `docker volume ls`.
- Named volumes are not attached to containers, and will survive container shutdown
- To re-connect a named volume, add `-v feedback:/app/feedback` when starting a new container