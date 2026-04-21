#!/bin/bash

mysqld_safe &

# Wait until MariaDB is actually ready
until mysqladmin ping -h "localhost" --silent; do
    sleep 1
done

# Run SQL setup
mysql -u root <<EOF

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;

EOF

# Stop background server
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# Start MariaDB in foreground
exec mysqld_safe