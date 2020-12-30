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
