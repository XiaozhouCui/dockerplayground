## Overall structure: 6 containers

- PHP Interpreter
- Nginx Web Server
- MySQL Database
- Composer
- Laravel Artisan
- npm

## Add Nginx container

- Add image `nginx:stable-alpine` into services of yaml file as "server"
- Publish port 8000:80
- Use Bind Mounts to pass config file "nginx.conf" into contatiner
- `/var/www/html` will be the folder to hold entire laravel app

## Add PHP container

- Create a php.dockerfile from image `php:7.4-fpm-alpine`
- php.dockerfile will install PDO as extension
- In yaml file, build new image as per php.dockerfile
- Use Bind Mounts to pass source code to container `./src:/var/www/html:delegated`
- `ports: "3000:9000"`. Nginx talks to container at 3000, and php image expose 9000

## Add MySQL container
- In yaml file, pull image from `mysql:5.7`
- Add environment variables using `env_file: ./env/mysql.env`

## Add composer utility container
- Create a composer.dockerfile from image `composer`
- In yaml file, build new images as per composer.dockerfile
- Use Bind Mounts to pass source code to container `./src:/var/www/html`

## Use composer to install laravel
- Run single container (composer) from yaml using utility container
- Run `docker-compose run --rm composer create-project --prefer-dist laravel/laravel .`
- "." referss to the `/var/www/html` folder inside container, and will be reflected in local `src` folder thanks to the Bind Mounts

## Start laravel on 8000
- In src folder, update .env file: `DB_HOST=mysql DB_DATABASE=homestead DB_USERNAME=homestead DB_PASSWORD=secret`, so the values are the same as mysql.env
- Use docker-compose to run selected services `docker-compose up -d --build server php mysql`
- `--build` force docker-compose to re-build image if something changes
- In yaml add `depends_on: php mysql` to server, then only need to run `docker-compose up -d --build server`

## Add artisan container
- In yaml file, build artisan image as per `php.dockerfile` (artisan share same dockerfile with php)
- Override dockerfile entrypoint in yaml `entrypoint: ["php", "/var/www/html/artisan"]`
- While the Nginx server is running, test artisan and mysql by migrating data
- Run `docker-compose run --rm artisan migrate`

## Add npm container
- In yaml file, pull node image
- Override working_dir and entrypoint

## Add Nginx dockerfile
- Bind Mounts mirroring is good for dev, but not good for prod/deploy
- To deploy, we need to create a nginx.dockerfile and COPY necessary contents into image
- In dockerfile, first copy nginx.conf to /etc/nginx/conf.d/, and rename file to default.conf
- Then copy src folder to /var/www/html
- Once the docker file is ready, update server in yaml file to point to this dockerfile to build image.