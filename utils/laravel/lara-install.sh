#!/bin/sh

if [ -z "$(ls -A /var/www/main)" ]; then
    echo "Folder /var/www/main is empty - continue. Wait..."
else
    echo "Folder /var/www/main is not empty. Exit"
    exit
fi

cd /var/www
composer create-project --prefer-dist laravel/laravel=$1 main
# addons
cd  /var/www/main
cp .env.example .env
php artisan key:generate
# Addons
# composer require doctrine/dbal
# composer require predis/predis
# Later...
# composer require --dev phpstan/phpstan
