FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

# Use image's internal command to install pdo
RUN docker-php-ext-install pdo pdo_mysql