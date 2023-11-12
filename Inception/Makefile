# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cmariot <cmariot@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/08/31 16:08:49 by cmariot           #+#    #+#              #
#    Updated: 2023/11/11 22:17:20 by cmariot         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PROJECT_NAME 				= inception

DOCKER_COMPOSE_FILE			= srcs/docker-compose.yml

HOME_PATH					= .

DOCKER_COMPOSE_COMMAND		= sudo docker compose \
							  -f ${DOCKER_COMPOSE_FILE} \
							  -p ${PROJECT_NAME}
up: create_directories
	${DOCKER_COMPOSE_COMMAND} up --pull never --build

clean: stop
	docker system prune -a --force

fclean: stop rm_directories
	docker system prune -a --force --volumes
	docker volume rm -f srcs_mariadb_volume srcs_wordpress_volume srcs_nginx_volume

re: fclean up

sh_nginx:
	${DOCKER_COMPOSE_COMMAND} exec nginx sh

sh_mariadb:
	${DOCKER_COMPOSE_COMMAND} exec mariadb sh

sh_wordpress:
	${DOCKER_COMPOSE_COMMAND} exec wordpress sh

ps:
	${DOCKER_COMPOSE_COMMAND} ps

list:
	@printf "CONTAINERS LIST :\n"
	@docker container ls
	@printf "\nIMAGES LIST :\n"
	@docker image ls
	@printf "\nVOLUMES LIST :\n"
	@docker volume ls
	@printf "\nNETWORKS LIST :\n"
	@docker network ls

image:
	${DOCKER_COMPOSE_COMMAND} images

pause:
	${DOCKER_COMPOSE_COMMAND} pause

unpause:
	${DOCKER_COMPOSE_COMMAND} unpause

start:
	${DOCKER_COMPOSE_COMMAND} start

stop:
	sudo docker compose -f ${DOCKER_COMPOSE_FILE} stop

restart:
	${DOCKER_COMPOSE_COMMAND} restart

create_directories:
	mkdir -p ${HOME_PATH}/srcs/data/mariadb\
		${HOME_PATH}/srcs/data/wordpress

rm_directories:
	rm -rf ${HOME_PATH}/srcs/data/mariadb\
		${HOME_PATH}/srcs/data/wordpress
