FROM node

WORKDIR /app

COPY package.json .

RUN npm install

# .dockerignore file will ignore specified folder when copying files to imgage
COPY . .

ARG DEFAULT_PORT=80

# environment variable
ENV PORT $DEFAULT_PORT

# $PORT is the environment defined shown above
EXPOSE $PORT

# # Anonymous volumn specifies a volumn path inside container
# VOLUME [ "/app/feedback" ]

CMD ["npm", "start"]