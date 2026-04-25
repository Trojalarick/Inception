NAME = inception

COMPOSE = docker 	compose -f srcs/docker-compose.yml

all: up

up:
	$(COMPOSE) up --build -d

#keep data
down:
	$(COMPOSE) down

#delete data
clean:
	$(COMPOSE) down -v

fclean:
	$(COMPOSE) down -v --rmi all
	docker system prune -af

re: fclean all

.PHONY: all up down clean fclean re
