## Container communicating to internet 
- No need to configure anything, a running container can send HTTP requests to the internet

## Container communicating to local machine services (MongoDB)
- Need to convert "localhost" to "host.docker.internal"
- `mongodb://host.docker.internal:27017/swfavorites`

## Container to container communicating: Basic Solution
- Get the IP address of contaimer "mongodb", `docker container inspect mongodb`
- Find the "IPAddress" which is `172.17.0.2`
- Update the connection string in app.js `mongodb://172.17.0.2:27017/swfavorites`

## Container to container communicating: Docker Network
- Create a docker network `docker network create favo-net`
- When starting the mongodb container, add `--network` option
- Run `docker run -d --name mongodb --network favo-net mongo`
- Update the connection string in app.js `mongodb://mongodb:27017/swfavorites`
- `mongodb` in the above string is the name of container under docker network `favo-net`
- Rebuild favo image and run `docker run --name favo --network favo-net -d --rm -p 3000:3000 favo`
- Now containers `favo` and `mongodb` can talk to each other uder network `favo-net`
