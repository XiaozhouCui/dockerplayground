## Dockerise MongoDB
- No need to create Dockerfile, MongoDB already have an official image "mongo"
- Default internal port is 27017, specify external port to be 27018 (avoid 27017 from local machine mongodb)
- In backend app.js, change conn string to 27018 `mongodb://localhost:27018/course-goals`
- Run `docker run --name mongodb --rm -d -p 27018:27017 mongo`

## Dockerise Node App
- Create Dockerfile in backend/, expose port 80
- In backend app.js, replace `localhost` with `host.docker.internal` in conn string 
- Build image, run `docker build -t goals-node .`
- Start container, run `docker run --name goals-backend --rm -d -p 80:80 goals-node`

## Dockerise React SPA
- Create Dockerfile in frontend/, also FROM "node" image, EXPOSE port 3000
- Build image, run `docker build -t goals-react .`
- React app need to run in interactive mode, add `-it` after `docker run`
- Start container, run `docker run -it --name goals-frontend --rm -d -p 3000:3000 goals-react`

## Add docker network
- Create a new network called "goals-net", run `docker network create goals-net`
- Start mongodb with network name `docker run --name mongodb --rm -d --network goals-net mongo`
- Update backend app.js, `mongodb://mongodb:27017/course-goals`
- Rebuild goals-node image `docker build -t goals-node .`
- Start backend with network name `docker run --name goals-backend --rm -d --network goals-net goals-node`
- In frontend App.js, replacing `localhost` with `goals-backend` will NOT work, because React is running in browser which don't recognise the server side container name `goals-backend`
- Need to restart `goals-backend` and publish to port 80, because React have to call `localhost` without docker network (backend only).
- Restart backend container on prot 80 `docker run --name goals-backend --rm -d -p 80:80 --network goals-net goals-node`
- React code runs in browser instead of container, so no need to add `--network`
- Start react container, run `docker run -it --name goals-frontend --rm -d -p 3000:3000 goals-react`

## Add Volume and Environemnt Variables to mongodb
- In mongo image, data is stored in `/data/db` inside container, ENV are called `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD`
- Add volume `data` to the mongodb container `docker run --name mongodb -v data:/data/db --rm -d --network goals-net mongo`
- Add auth credentials as environment variables `docker run --name mongodb -v data:/data/db --rm -d --network goals-net -e MONGO_INITDB_ROOT_USERNAME=joe -e MONGO_INITDB_ROOT_PASSWORD=secret mongo`
- Since auth is required, need to update backend app.js `mongodb://joe:secret@mongodb:27017/course-goals?authSource=admin`
- Rebuild backend image and restart goals-backend `docker run --name goals-backend --rm -p 80:80 --network goals-net goals-node`