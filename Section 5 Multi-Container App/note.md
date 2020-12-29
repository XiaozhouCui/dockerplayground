## Dockerise MongoDB
- Default expose port is 27017
- In backend app.js, change conn string to 27018 `mongodb://localhost:27018/course-goals`
- Run `docker run --name mongodb --rm -d -p 27018:27017 mongo`