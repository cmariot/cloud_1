#!/bin/bash

# This script is used to deploy the Inception project

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Variables
NGINX_ENV_FILE=srcs/requirements/nginx/.env
MARIADB_ENV_FILE=srcs/requirements/mariadb/.env
WORDPRESS_ENV_FILE=srcs/requirements/wordpress/.env

# Functions

# This function is used to check if the .env file exists
# It returns 0 if the file exists, 1 otherwise

check_env_file()
{
    if [ -f $1 ];
    then
        return 0
    else
        return 1
    fi
}

# If the env file doesn't exist, it is created
if []
