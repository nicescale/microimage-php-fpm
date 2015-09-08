from microimages/alpine

maintainer william <wlj@nicescale.com>

label service=php

run apk add --update php-fpm php-curl php-sockets php-cli php-openssl php-mysqli

workdir /app

add php-fpm.conf /etc/php/php-fpm.conf

expose 80 443 9000

cmd ["php-fpm"]
