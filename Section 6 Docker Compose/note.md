## Docker-compose setup
- Add docker-compose.yaml file
- No need to detach or remove containers, docker-compose will auto shutdown and remove
- No need to add networks, docker-compose will auto create default network
- Run `docker-compose up -d` to start compose in detached mode
- To shutdown and remove containers and networks, run `docker-compose down`
- To remove volumes, run `docker-compose down -v` 

## Docker-compose with multiple containers
- In yaml file, add backend service and use `build: ./backend` to point to the Dockerfile in backend folder
- Relative path can be used for bind mounts in docker-compose `volumes: ./backend:app`
- Add `depends_on` for backend, becaulse node app needs mongodb to be up and running first.
- In db connection string, `mongodb` still works because it is the name of service in yaml, even though the container's name is `compose-01-starting-setup_mongodb_1`
- To use custom container names, add `container_name: mongodb` to mongodb service in yaml file 

## Interactive mode for docker-composer
- Add frontend service to yaml file
- To represent `-it` option in CLI, add `stdin_open: true` and `tty: true` in yaml file