#! /bin/sh


WORDPRESS_CONFIG_FILE=/var/www/html/wp-config.php


# WP-CLI = Command line interface for WordPress
install_wp_cli()
{
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
}


# Download wordpress
download_wordpress()
{
	echo "Downloading WordPress"
	wp core download --path=/var/www/html --force --skip-content
}


# Configuration of wp-config.php
config_wordpress()
{
	echo "WordPress configuration"
	cd /var/www/html

	sleep 10
	wp config create \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=${MYSQL_DB_HOST} \
		--dbprefix=${MYSQL_DB_PREFIX}

	sed -i "62i define('FS_METHOD', 'direct');" wp-config.php

}


# Wordpress installation
install_wordpress()
{
	echo "WordPress installation"
	cd /var/www/html

	wp core install \
		--url=${SITE_URL} \
		--title=${SITE_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--skip-email

	#Change permalinks structure
	wp rewrite structure /%postname%/

	# Install the default theme
	wp theme install twentytwentyfour --force
    wp theme activate twentytwentyfour
}


main()
{
	if [ -f "$WORDPRESS_CONFIG_FILE" ];
	then
		echo "WordPress is already downloaded."
	else
        install_wp_cli
		echo "Wordpress installation ..."
		download_wordpress
		config_wordpress
		install_wordpress
		wp cron event run --due-now
        chown -R www-data:www-data /var/www/html
		echo "The WordPress installation is completed."
        rm -f /usr/local/bin/wp
	fi
}


main
exec php-fpm8 -F
