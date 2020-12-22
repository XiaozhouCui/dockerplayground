FROM node

WORKDIR /app

# all files will be copied to /app folder in the image file system
COPY . /app

# RUN: executed "npm install" when image is created
RUN npm install

EXPOSE 80

# CMD is always the last command in Dockerfile
# CMD: executed "node server.js" when container is started
CMD ["node",  "server.js"]
