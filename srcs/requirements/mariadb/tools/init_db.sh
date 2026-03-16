#!/bin/sh

# Initialize MariaDB data directory if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily to configure it
echo "Starting MariaDB temporarily for configuration..."
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
MARIADB_PID=$!

# Wait for MariaDB to start
sleep 5

# Configure database and users
echo "Configuring database and users..."
mysql -u root << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Stop temporary MariaDB
kill $MARIADB_PID
sleep 2

# Start MariaDB normally
echo "Starting MariaDB service..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
