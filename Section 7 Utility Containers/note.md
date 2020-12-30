## Execute command inside a running container
- First, start a node container `docker run -it -d node`
- Run `npm init` inside container `docker exec -it cool_proskuriakova npm init`
- Alternatively, we can enter command when starting a container
- Override the default `CMD [...]` by adding new command at the end `docker run -it node npm init`
- Above container will auto stop once finished `npm init` entry

## Build a utility container
- "Utility Container" is just an environment to run certain commands.
- "Utility Container" can work with `docker run` and `docker-compose run`.
- First, create a Dockerfile
- Run `docker run -it -v "%cd%":/app  node-util npm init`
- Above cmd will also create a package.json file in local machine
- Once the util container is created, we no longer need Node.js on local machine

## Utilising ENTRYPOINT
- In Dockerfile, add `ENTRYPOINT ["npm"]`
- Rebuild image `docker build -t mynpm .`
- Run `docker run -it -v "%cd%":/app mynpm install express`
- The last command `install express` will be appended to ENTRYPOINT `npm` to form `npm install express`
- A package-lock.json file and node_modules folder will be generated in local machine

## Using Docker-Composer
- Add npm as service, and build from Dockerfile in current folder
- Run `docker-compose run --rm npm init`, where `npm` is the name of service