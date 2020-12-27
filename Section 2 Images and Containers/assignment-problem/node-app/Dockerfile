# Define "name:tag" combination of an image
# "node" is the group name of images, while the optional "12" is the specialised tag of an image
FROM node

# Every instruction in an image creates a cacheable layer
# Layer help with image re-building and sharing
WORKDIR /app

# in this upper layer, copy package.json to /app folder in the image
# once cached, docker will not run "npm install" again
COPY package.json /app

# RUN: executed "npm install" when image is created
RUN npm install

# in this lower layer, copy all files will to /app folder in the image file system
COPY . /app

EXPOSE 3000

# CMD is always the last command in Dockerfile
# CMD: executed "node server.js" when container is started
CMD ["node",  "server.js"]
