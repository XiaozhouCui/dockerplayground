## Add docker compose
- Add docker-compose.yaml file
- No need to add `-d --rm`, docker-compose will auto shutdown and remove containers
- No need to add networks, docker-compose will auto create default network
- Run `docker-compose up -d` to start compose in detached mode
- To shutdown and remove containers and networks, run `docker-compose down`
- To remove volumes, run `docker-compose down -v` 