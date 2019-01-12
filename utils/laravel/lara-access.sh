#!/bin/sh

if [ -z "$(ls -A /var/www/main)" ]; then
   echo "DIR EMPTY - EXIT!"
else
   # В случае если консольные команды запускаются под одним пользователем а PHP-FPM работает под www-data возникает проблема...
   echo "UNCOMMENT LINES!"
   #chown www-data:www-data -R /var/www/main/storage/framework/
   #chown www-data:www-data -R /var/www/main/storage/logs/
fi
