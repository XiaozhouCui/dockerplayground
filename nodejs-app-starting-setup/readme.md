## "docker run" and "docker start"

- `docker run -p 3000:80 CONTAINER` will automatically attach to the running container, unless `-d` is added.
- `docker start CONTAINER` will re-start a container without attaching to its console.
- To check the logs in a detached container, run `docker logs CONTAINER`
- To keep listening to a detached container, run `docker logs -f CONTAINER`