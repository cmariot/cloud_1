#!/bin/bash


# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    deploy.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cmariot <cmariot@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/11/12 21:27:54 by cmariot           #+#    #+#              #
#    Updated: 2023/11/12 21:28:04 by cmariot          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


# This script is used to deploy the Inception project


# Colors
BLUE='\033[0;34m'
RED='\033[0;31m'
RC='\033[0m'

# Environment variables
ENV_FILE="Inception/.env"

# WORDPRESS
SITE_TITLE=Blog
SITE_URL=https://charles-mariot.fr
URL=charles-mariot.fr

# MARIADB
MYSQL_DB_HOST=mariadb:3306
MYSQL_DATABASE=wordpress
MYSQL_DB_PREFIX=wp_

# REDIS
WP_REDIS_HOST=redis
WP_REDIS_PORT=6379



header()
{

    clear

    echo -e "
    ${BLUE}
     ____ _     ___  _   _ ____     _
    / ___| |   / _ \| | | |  _ \   / |
   | |   | |  | | | | | | | | | |  | |
   | |___| |__| |_| | |_| | |_| |__| |
    \____|_____\___/ \___/|____/___|_|
    ${RC}

  Deploying Inception on a cloud platform.
    "

}


check_env_file()
{

    # If the .env file doesn't exist, we need to create it

    if [ ! -f $ENV_FILE ];
    then
        echo
        echo
        echo -e "☁️ ${BLUE}Let's add some variables to the .env file ! ${RC}"
        echo
        read_input
        create_env_file
    fi
    echo

}


read_input()
{

    # We ask the user to enter the variables

    echo -e "${BLUE}Enter the WordPress admin user: ${RC}"
    read WP_ADMIN_USER

    echo -e "${BLUE}Enter the WordPress admin email: ${RC}"
    read WP_ADMIN_EMAIL

    echo -e "${BLUE}Enter the WordPress admin password: ${RC}"
    read -s WP_ADMIN_PASSWORD
    echo -e "Ok"

    echo -e "${BLUE}Enter the database admin user: ${RC}"
    read MYSQL_USER

    echo -e "${BLUE}Enter the database admin password: ${RC}"
    read -s MYSQL_PASSWORD
    echo -e "Ok"

}


create_env_file()
{

    # Write the variables in the .env file

    echo "# WORDPRESS" > $ENV_FILE
    echo "SITE_TITLE=$SITE_TITLE" >> $ENV_FILE
    echo "SITE_URL=$SITE_URL" >> $ENV_FILE
    echo "URL=$URL" >> $ENV_FILE

    echo >> $ENV_FILE

    echo "# WORDPRESS ADMIN" >> $ENV_FILE
    echo "WP_ADMIN_USER=$WP_ADMIN_USER" >> $ENV_FILE
    echo "WP_ADMIN_PASSWORD=$WP_ADMIN_PASSWORD" >> $ENV_FILE
    echo "WP_ADMIN_EMAIL=$WP_ADMIN_EMAIL" >> $ENV_FILE
    echo "WP_REDIS_HOST=$WP_REDIS_HOST" >> $ENV_FILE
    echo "WP_REDIS_PORT=$WP_REDIS_PORT" >> $ENV_FILE

    echo >> $ENV_FILE

    echo "# MARIADB" >> $ENV_FILE
    echo "MYSQL_DB_HOST=$MYSQL_DB_HOST" >> $ENV_FILE
    echo "MYSQL_USER=$MYSQL_USER" >> $ENV_FILE
    echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> $ENV_FILE
    echo "MYSQL_DATABASE=$MYSQL_DATABASE" >> $ENV_FILE
    echo "MYSQL_DB_PREFIX=$MYSQL_DB_PREFIX" >> $ENV_FILE

    echo
    echo -e "${BLUE}The .env file has been created.${RC}"
    echo "\n"

}


deploy_with_ansible()
{

    echo -e "${BLUE}Deploying the project with Ansible ...${RC}"

    # We run the playbook.yml file with the inventory.conf file
    # The playbook.yml file contains the tasks to deploy the project
    # The inventory.conf file contains the host, the user and the ssh key

    ansible-playbook ./ansible/playbook.yml -i ./ansible/inventory.conf

    echo

}


open_website()
{

    # Check if the website responds with a 200 status code (OK)
    # If it does, we open the website in the default browser
    # If the website is not up yet, we wait 10 seconds and we try again

    # For loop with 10 iterations (10 * 10 seconds = 100 seconds)

    echo -e "Trying to open $URL in the browser.\n"

    for i in {1..10}
    do
        STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $SITE_URL)
        if [ $STATUS_CODE -eq 200 ];
        then
            open $SITE_URL
            break
        else
            # If the website is not up after 100 seconds, we exit the loop
            if [ $i -eq 10 ];
            then
                echo
                echo -e "${RED}The website is not up after 100 seconds.${RC}"
                echo -e "${RED}Please check the logs.${RC}"
                echo
                exit 1
            else
                echo -e "Connexion failed, retrying in 10 seconds."
            fi
        fi
    done

}


main()
{

    header
    check_env_file
    deploy_with_ansible
    open_website

}


main
