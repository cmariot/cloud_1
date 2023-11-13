# syntax=docker/dockerfile:1

# Get the container Image
FROM alpine:3.16

# Update the index of available packages,
# Upgrade the currently installed packages
# And install php8 and php8 packages
RUN apk update && apk upgrade && apk add --no-cache\
	curl\
	mariadb-client\
	php\
	php8-curl\
	php8-ctype\
	php8-dom\
	php8-exif\
	php8-fileinfo\
	php8-fpm\
	php8-gd\
	php8-iconv\
	php8-intl\
	php8-mbstring\
	php8-mysqli\
	php8-pecl-imagick\
	php8-phar\
	php8-redis\
	php8-session\
	php8-xml\
	php8-zip


# Copy php config files
COPY ./conf/www.conf	/etc/php8/php-fpm.d/
COPY ./conf/php.ini		/etc/php8/

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
