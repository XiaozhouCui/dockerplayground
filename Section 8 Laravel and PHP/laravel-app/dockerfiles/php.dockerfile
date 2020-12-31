FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

# copy src folder for deployment
# COPY src .

# Use image's internal command to install pdo
RUN docker-php-ext-install pdo pdo_mysql
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel
