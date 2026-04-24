#!/bin/bash

cd /var/www/html

# Wait for MariaDB
until nc -z mariadb 3306; do
    sleep 1
done

# Create wp-config if not exists
if [ ! -f wp-config.php ]; then
    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/wordpress/" wp-config.php
    sed -i "s/username_here/salhali/" wp-config.php
    sed -i "s/password_here/wp_password/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php

    # ADD REDIS CONFIG (IMPORTANT: BEFORE wp-settings)
    sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i \
define('WP_REDIS_HOST', 'redis');\n\
define('WP_REDIS_PORT', 6379);\n\
define('WP_REDIS_CLIENT', 'phpredis');\n" wp-config.php
fi

# ALWAYS remove old cache file (VERY IMPORTANT)
rm -f /var/www/html/wp-content/object-cache.php

# Start PHP
exec php-fpm8.4 -F