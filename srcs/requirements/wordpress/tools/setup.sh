#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html

# Download WordPress
wget https://wordpress.org/trixie.tar.gz
tar -xzf trixie.tar.gz --strip-components=1
rm trixie.tar.gz

# Permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
exec php-fpm8.4 -F