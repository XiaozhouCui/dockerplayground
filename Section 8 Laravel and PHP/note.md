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

## Run single container (composer) from yaml using utility container
- Use composer to install laravel
- Run `docker-compose run --rm composer create-project --prefer-dist laravel/laravel .`
- "." referss to the `/var/www/html` folder inside container, and will be reflected in local `src` folder thanks to the Bind Mounts

## Start laravel on 8000
- In src folder, update .env file: `DB_HOST=mysql DB_DATABASE=homestead DB_USERNAME=homestead DB_PASSWORD=secret`, so the values are the same as mysql.env
- Use docker-compose to run selected services `docker-compose up -d --build server php mysql`
- `--build` force docker-compose to re-build image if something changes
- In yaml add `depends_on: php mysql` to server, then only need to run `docker-compose up -d --build server`