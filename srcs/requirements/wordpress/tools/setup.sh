#!/bin/bash

set -ex

cd /var/www/html

# Wait for MariaDB
echo " Waiting for MariaDB..."
until nc -z "$DB_HOST" 3306; do sleep 1; done
echo " MariaDB is up."

# ── Download WordPress via WP-CLI ──────────────────────────────
if [ ! -f wp-login.php ]; then
    echo "⬇  Downloading WordPress..."
    wp core download --allow-root
fi

# ── Create wp-config.php ───────────────────────────────────────
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --allow-root

    # Redis constants
    wp config set WP_REDIS_HOST     redis          --allow-root
    wp config set WP_REDIS_PORT     6379 --raw     --allow-root
    wp config set WP_REDIS_CLIENT   phpredis       --allow-root
fi

# ── Install WordPress (DB tables + admin account) ──────────────
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo " Installing WordPress..."
    wp core install \
        --url="$SITE_URL" \
        --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASS" \
        --admin_email="$ADMIN_EMAIL" \
        --skip-email \
        --allow-root
fi

# ── Create regular user if missing ────────────────────────────
if ! wp user get "$REGULAR_USER" --allow-root &>/dev/null; then
    echo " Creating user '$REGULAR_USER'..."
    wp user create "$REGULAR_USER" "$REGULAR_EMAIL" \
        --role="$REGULAR_ROLE" \
        --user_pass="$REGULAR_PASS" \
        --allow-root
fi

# ── Redis Cache plugin ─────────────────────────────────────────
if [ ! -d wp-content/plugins/redis-cache ]; then
    echo " Installing Redis Cache plugin..."
    wp plugin install /tmp/redis-cache.zip --activate --allow-root
else
    wp plugin activate redis-cache --allow-root 2>/dev/null || true
fi

# Always drop stale object-cache drop-in so WP-CLI can re-enable cleanly
rm -f wp-content/object-cache.php

wp redis enable --allow-root || true

# Fix ownership after all WP-CLI writes
chown -R www-data:www-data /var/www/html

echo " Starting PHP-FPM..."
exec php-fpm8.4 -F