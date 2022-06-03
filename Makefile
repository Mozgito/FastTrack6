ROOT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

up:
	docker-compose up -d

stop:
	docker-compose stop

down:
	docker-compose down -v --remove-orphans

rebuild:
	docker-compose down -v --remove-orphans
	docker-compose rm -vsf
	docker-compose up -d --build

cont:
	docker exec -it fasttrack6_php_1 sh

migrate:
ifneq ($(wildcard $(ROOT_DIR)/migrations/Version*),)
	@docker exec fasttrack6_php_1 php bin/console --no-ansi --no-interaction doctrine:migrations:migrate
	@docker exec fasttrack6_php_1 php bin/console --no-ansi --no-interaction cache:clear
else
	@echo "No migrations found"
endif

dump-db:
	docker exec fasttrack6_database_1 pg_dump -U mozg -d test > db_dump.sql

restore-db:
	docker exec -i fasttrack6_database_1 psql -U mozg test < db_dump.sql