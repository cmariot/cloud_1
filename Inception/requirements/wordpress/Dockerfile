# syntax=docker/dockerfile:1

# Get the container Image
FROM alpine:3.18

# Update the index of available packages,
# Upgrade the currently installed packages
# And install php8 and php8 packages
RUN apk update && apk upgrade

# Install php8 and php8 packages
RUN apk add curl \
    php81 \
    php81-fpm \
    php81-opcache \
    php81-gd \
    php81-zlib \
    php81-curl \
    php81-mysqli \
    php81-pdo_pgsql \
    php81-phar \
    php81-simplexml \
    php81-dom \
    php81-xml \
    php81-xmlwriter \
    php81-xmlreader \
    php81-zip \
    php81-xsl \
    php81-iconv \
    mysql-client \
    php81-exif \
    php81-fileinfo \
    php81-pecl-imagick \
    php81-mbstring \
    php81-intl

# Copy php config files
COPY ./conf/www.conf	    /etc/php81/php-fpm.d/
COPY ./conf/php.ini		    /etc/php81/
COPY ./conf/php-fpm.conf	/etc/php81/

RUN mkdir /var/run/php

# Add user www-data, and give him the right to write in /var/www
RUN adduser -S -D -s /sbin/nologin -h /var/www -G www-data www-data

# Copy the wordpress installation script
COPY ./tools/wordpress_install.sh /var/www/

# The installation script must be executable and owned by www-data
RUN chown -R www-data:www-data /var/www/wordpress_install.sh

# Change the user to www-data
USER www-data

# Create the directory /var/www/html
RUN mkdir -p /var/www/html

# Make the script executable
RUN chmod +x /var/www/wordpress_install.sh

# Expose the port 9000
EXPOSE 9000

# Install wp and run php
USER root
CMD ["/var/www/wordpress_install.sh"]
