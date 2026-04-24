#!/bin/bash

# Start MariaDB in background
mysqld_safe &

# Wait until ready
until mysqladmin ping -h "localhost" --silent; do
    sleep 1
done

# ONLY run setup if database doesn't exist
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing database..."

    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;
EOF
fi

# Stop background server
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# Start in foreground (important for Docker)
exec mysqld_safe