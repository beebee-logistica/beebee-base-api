FROM alpine:edge

MAINTAINER Juliano Petronetto <juliano@petronetto.com.br>

# Install packages
RUN apk --update add --no-cache \
        nginx \
        curl \
        supervisor \
        gd \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        php7 \
        php7-dom \
        php7-fpm \
        php7-mbstring \
        php7-mcrypt \
        php7-opcache \
        php7-pdo \
        php7-pdo_pgsql \
        php7-xml \
        php7-phar \
        php7-openssl \
        php7-json \
        php7-ctype \
        php7-session \
        php7-gd \
        && rm -rf /var/cache/apk/*

# Creating symbolic link to php
RUN ln -s /usr/bin/php7 /usr/bin/php

# Configure Nginx
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/default /etc/nginx/sites-enabled/default

# Configure PHP-FPM
COPY config/php/php.ini /etc/php7/php.ini
COPY config/php/www.conf /etc/php7/php-fpm.d/www.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisord.conf

# Add application
RUN mkdir -p /app
WORKDIR /app

# Set UID for www-data user to 33
RUN deluser xfs \
    && delgroup www-data \
    && addgroup -g 33 -S www-data \
    && adduser -u 33 -D -S -G www-data -h /app -g www-data www-data \
    && chown -R www-data:www-data /var/lib/nginx

# Start Supervisord
ADD config/start.sh /start.sh
RUN chmod 755 /start.sh

# Start Supervisord
CMD ["/start.sh"]