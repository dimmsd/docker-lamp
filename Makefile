#!/usr/bin/make

.DEFAULT_GOAL := help
.PHONY : help config-test set-log-access set-www-access build up down exec-nginx exec-httpd exec-as-root- exec-as-user \
 fpm-status fpm-exec-index

cnf ?= .env

ifneq ("$(wildcard $(cnf))","")
include $(cnf)
else
$(error "ERROR! File .env not found. Rename .env.example => .env")
endif

FPMIP=$(shell docker inspect php-fpm-$(MAIN_DOMAIN) | grep '"IPAddress"' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

CURRENT_TIME=$(shell date +"%d.%m.%Y-%H.%M")

PWD=$(shell pwd)

help:
	@echo "Help:"
	@echo "\tconfig-test - test docker-compose.yml"
	@echo "\tset-www-access - set access for ./www data: 644 for files and 755 for dirs"
	@echo "\tup - up container"
	@echo "\tdel-database - Delete database from ./db folder"
	@echo "\tdel-logs - Delete all logs from ./log* folder"
	@echo "Next commands execute after success up services:"
	@echo "\tdown - down container"
	@echo "\texec-nginx - attach to NGINX container and start bash session"
	@echo "\texec-httpd - attach to HTTPD container and start bash session"
	@echo "\texec-mysql - attach to MYSQL container and start bash session"
	@echo "\texec-as-root - attach to PHP_FPM container and start bash session"
	@echo "\texec-as-user - attach to PHP_FPM container and start bash session under user $(OWN_USER)"
	@echo "\tfpm-status - show PHP-FPM status"
	@echo "\tfpm-exec-index - show result execute ./www/main/index.php"
	@echo "\tshow-mysql-log - Show log MYSQL container"
	@echo "\tbackup-mysql - Backup MYSQL database"
	@echo "\tcheck-version - Check version images"
	@echo "\tcheck-site - Execute for test curl $(MAIN_DOMAIN) (from container)"
	@echo "Addons:"
	@echo "\tinstall-laravel - Install Laravel"
config-test:
	@docker-compose -f docker-compose.yml config
set-www-access:
	find ./www/ -type f -exec chmod 644 {} \;
	find ./www/ -type d -exec chmod 755 {} \;
up:
	@docker-compose up -d
down:
	@docker-compose down
exec-mysql:
	@docker exec -it db-$(MAIN_DOMAIN) bash
exec-nginx:
	@docker exec -it nginx-$(MAIN_DOMAIN) bash
exec-httpd:
	@docker exec -it httpd-$(MAIN_DOMAIN) bash
exec-as-root:
	@docker exec -it php-fpm-$(MAIN_DOMAIN) bash
exec-as-user:
	@docker exec -u $(OWN_USER) -it php-fpm-$(MAIN_DOMAIN) bash
fpm-status:
	@docker exec -it php-fpm-$(MAIN_DOMAIN) /usr/local/bin/test-php-fpm.sh  127.0.0.1 status status
fpm-exec-index:
	@docker exec -it php-fpm-$(MAIN_DOMAIN) /usr/local/bin/test-php-fpm.sh 127.0.0.1 index.php $(MAIN_PATH)/index.php
show-mysql-log:
	@docker logs db-$(MAIN_DOMAIN)
backup-mysql:
	@echo "Backup database"
	@docker exec "db-"$(MAIN_DOMAIN) sh -c 'exec mysqldump --all-databases -uroot -p"$(MYSQL_ROOT_PASSWORD)" | gzip -c'   > ./db-backup/all-databases-$(CURRENT_TIME).sql.gz
	@docker exec "db-"$(MAIN_DOMAIN) sh -c 'exec mysqldump $(MYSQL_DATABASE) -uroot -p"$(MYSQL_ROOT_PASSWORD)" | gzip -c'   > ./db-backup/db-$(MYSQL_DATABASE)-$(CURRENT_TIME).sql.gz
check-version:
	@./utils/check-version.sh docker-ubuntu-php-fpm php-fpm-$(MAIN_DOMAIN) dimmsd/ubuntu-php-fpm:${UBUNTU_VERSION}.${PHP_VERSION}
	@./utils/check-version.sh docker-ubuntu-nginx nginx-$(MAIN_DOMAIN) dimmsd/ubuntu-nginx:${UBUNTU_VERSION}.${NGINX_VERSION}
	@./utils/check-version.sh docker-ubuntu-httpd httpd-$(MAIN_DOMAIN) dimmsd/ubuntu-httpd:${UBUNTU_VERSION}
check-site:
	@docker exec -it nginx-$(MAIN_DOMAIN) /tmp/utils/test7.sh
del-database:
	@echo "Delete database"
	@docker run --rm \
                    -v $(PWD)/db:/tmp/mysql \
                    -v $(PWD)/utils:/tmp/utils \
                    -it dimmsd/ubuntu-base:16.04 /tmp/utils/delete-mysql-db.sh
del-logs:
	@echo "Delete logs"
	@docker run --rm \
                    -v $(PWD)/log-apache:/tmp/log-apache \
                    -v $(PWD)/log-fpm:/tmp/log-fpm \
                    -v $(PWD)/log-nginx:/tmp/log-nginx \
                    -v $(PWD)/log-xdebug:/tmp/log-xdebug \
                    -v $(PWD)/utils:/tmp/utils \
                    -it dimmsd/ubuntu-base:16.04 /tmp/utils/delete-logs.sh
install-laravel:
	@docker exec -u $(OWN_USER) -it php-fpm-$(MAIN_DOMAIN) /tmp/utils/laravel/lara-install.sh $(LARAVEL_VERSION)


