NAME = inception

SRC_DIR = srcs
COMPOSE = docker-compose -f $(SRC_DIR)/docker-compose.yml

DATA_DIR = /home/jomunoz42/data
DB_DIR = $(DATA_DIR)/mariadb
WP_DIR = $(DATA_DIR)/wordpress

all: up

up:
	mkdir -p $(DB_DIR) $(WP_DIR)
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down -v --rmi all --remove-orphans
	sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all up down stop start restart logs ps clean fclean re
