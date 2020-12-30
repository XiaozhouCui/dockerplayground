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