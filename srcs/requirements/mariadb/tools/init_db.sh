#!/bin/bash
chown -R mysql:mysql /var/lib/mysql

mysqld_safe &

until mysqladmin ping -h localhost --silent; do
    sleep 1
done

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    echo "Initializing database..."
    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF
fi

mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
exec mysqld_safe