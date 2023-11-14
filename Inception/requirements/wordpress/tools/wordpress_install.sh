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

    # // adjust Redis host and port if necessary
    sed -i "63i define('WP_REDIS_HOST', '${WP_REDIS_HOST}');" wp-config.php
    sed -i "64i define('WP_REDIS_PORT', '${WP_REDIS_PORT}');" wp-config.php

    # // change the prefix and database for each site to avoid cache data collisions
    sed -i "65i define('WP_REDIS_PREFIX', 'blog_');" wp-config.php
    sed -i "66i define('WP_REDIS_DATABASE', 0);" wp-config.php

    # // reasonable connection and read+write timeouts
    sed -i "67i define( 'WP_REDIS_TIMEOUT', 1 );" wp-config.php
    sed -i "68i define( 'WP_REDIS_READ_TIMEOUT', 1 );" wp-config.php
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


install_redis_extensions()
{
    # Install Redis extensions
    wp plugin install redis-cache --activate
    wp plugin install wp-super-cache --activate

    # Enable Redis
    wp redis enable
}


clean_wordpress()
{
    echo "WordPress cleaning"
    cd /var/www/html

    # Remove default unused files
    rm ./readme.html
    rm ./license.txt
    rm ./wp-config-sample.php

    # Remove wp-cli
    rm -f /usr/local/bin/wp
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
        install_redis_extensions
		wp cron event run --due-now
        chown -R www-data:www-data /var/www/html
		echo "The WordPress installation is completed."
	fi
}


main
exec php-fpm81 -F
