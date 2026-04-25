NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml

all: up

up:
	mkdir -p /home/salhali/data/mariadb_data /home/salhali/data/wordpress_data
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean:
	$(COMPOSE) down -v --rmi all
	docker run --rm -v /home/salhali/data:/data alpine sh -c "rm -rf /data/mariadb_data /data/wordpress_data"

re: fclean all

.PHONY: all up down clean fclean re