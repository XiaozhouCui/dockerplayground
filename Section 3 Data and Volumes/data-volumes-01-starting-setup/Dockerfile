FROM node

WORKDIR /app

COPY package.json .

RUN npm install

# .dockerignore file will ignore specified folder when copying files to imgage
COPY . .

EXPOSE 80

# # Anonymous volumn specifies a volumn path inside container
# VOLUME [ "/app/feedback" ]

CMD ["npm", "start"]