FROM nginx:stable-alpine

WORKDIR /etc/nginx/conf.d

# copy local nginx.conf to /etc/nginx/conf.d in container
COPY nginx/nginx.conf .

# rename nginx.conf to default.conf
RUN mv nginx.conf default.conf

WORKDIR /var/www/html

# copy src folder to /var/www/html in container
COPY src .