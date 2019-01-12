## Dev environment for PHP

Ubuntu

Nginx (front-end)

Apache

Mysql

Php (5.6, 7.0, 7.1, 7.2, 7.3)

Contains php-fpm, php-cli, xdebug, composer.

Based on images:

[Ubuntu base image](https://github.com/dimmsd/docker-ubuntu-base)
[Ubuntu php-fpm image](https://github.com/dimmsd/docker-php-fpm)
[Ubuntu httpd image](https://github.com/dimmsd/docker-httpd)
[Ubuntu nginx image](https://github.com/dimmsd/docker-nginx)

### Using the `Makefile`

```
$ make help
config-test			Test docker-compose.yml
set-www-access			Set permissions for ./www folder : 644 for files and 755 for folders
up				Up services
down				Down services
exec-nginx			Attach to NGINX container and start bash session
exec-httpd			Attach to Apache container and start bash session
exec-mysql			Attach to MYSQL container and start bash session
exec-as-root			Attach to PHP-FPM container and start bash session
exec-as-user			Attach to PHP-FPM container and start bash session under user $(OWN_USER)
del-database			Delete database from ./db folder
del-logs			Delete all logs from ./log* folder
show-mysql-log			Show log MYSQL container
backup-mysql			Backup MYSQL database
check-version			Check version docker images (up services before!)
fpm-status			Show PHP-FPM status page
fpm-exec-index			Execute /var/www/main/index.php over PHP-FPM
install-laravel			Install Laravel
```

### Example demo

```
$ git clone git://github.com/dimmsd/docker-lamp.git
$ cd docker-lamp
$ cp .env.example .env
$ make up
## add example.loc in your /etc/hosts, see Environment section
## go example.loc in your browser
```

### Example Laravel

```
$ git clone git://github.com/dimmsd/docker-lamp.git
$ cd docker-lamp
$ cp .env.example .env
## Open .env file
## Uncomment line with Laravel version, example
## LARAVEL_VERSION=5.5
## Set variable MAIN_PATH as
## MAIN_PATH=/var/www/main/public
## Save .env file and exit
$ make up
$ make install-laravel
## add example.loc in your /etc/hosts, see Environment
## go example.loc in your browser
## for execute artisan command attach PHP-FPM container
make exec-as-user
user@e414a9a4b1ad:/var/www/main$ php artisan
```

### Environment

See `.env.example` for detail

Default domain is example.loc (variable MAIN_DOMAIN)

Default DocumentRoot folder for demo page is `./www/demo` (variable MAIN_PATH)

Default IP Httpd service in `.env.example` is 172.50.0.100

For testing example.loc from host system, add host name in `/etc/hosts` file

`172.50.0.100 example.loc www.example.loc`

### Run Docker commands without sudo

See this [section](https://github.com/dimmsd/docker-ubuntu-base#run-docker-commands-without-sudo).