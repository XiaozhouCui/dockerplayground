## Dockerise MongoDB
- No need to create Dockerfile, MongoDB already have an official image "mongo"
- Default internal port is 27017, specify external port to be 27018
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
