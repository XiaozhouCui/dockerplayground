## Dockerise MongoDB
- No need to create Dockerfile, MongoDB already have an official image "mongo"
- Default expose port is 27017
- In backend app.js, change conn string to 27018 `mongodb://localhost:27018/course-goals`
- Run `docker run --name mongodb --rm -d -p 27018:27017 mongo`

## Dockerise Node App
- Create Dockerfile in /backend
- In backend app.js, replace `localhost` with `host.docker.internal` in conn string 
- Build image, run `docker build -t goals-node .`
- Start container, run `docker run --name goals-backend --rm -d -p 80:80 goals-node`