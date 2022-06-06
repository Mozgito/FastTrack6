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
	@echo "==> Run migrations"
ifneq ($(wildcard $(ROOT_DIR)/migrations/Version*),)
	@docker exec fasttrack6_php_1 php bin/console --no-ansi --no-interaction doctrine:migrations:migrate
	@docker exec fasttrack6_php_1 php bin/console --no-ansi --no-interaction cache:clear
else
	@echo "==> No migrations found"
endif

fixtures:
	@echo "==> Loading test fixtures"
	@docker exec fasttrack6_php_1 php bin/console --no-ansi --no-interaction doctrine:fixtures:load

recreate-db:
	@echo "==> Dropping and creating db"
	@docker exec fasttrack6_php_1 php bin/console doctrine:database:drop --force
	@docker exec fasttrack6_php_1 php bin/console doctrine:database:create

dump-db:
	docker exec fasttrack6_database_1 pg_dump -U mozg -d fasttrack > db_dump.sql

restore-db:
	docker exec -i fasttrack6_database_1 psql -U mozg fasttrack < db_dump.sql

tests:
	@docker exec fasttrack6_php_1 php -dpcov.enabled=1 -dpcov.directory=src -dpcov.exclude="~vendor|tests|bin|src/Kernel.php|src/DataFixtures~" -d memory_limit=-1 vendor/bin/phpunit -c phpunit.xml.dist

.PHONY: tests