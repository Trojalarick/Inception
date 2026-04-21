#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html

# Download WordPress
wget https://wordpress.org/bullseye.tar.gz
tar -xzf bullseye.tar.gz --strip-components=1
rm bullseye.tar.gz

# Permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
exec php-fpm7.4 -F