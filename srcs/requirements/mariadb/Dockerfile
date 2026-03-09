# Alpine = a very small Linux operating system

# Start building my image from Alpine Linux version 3.18.”


FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create required directories
RUN mkdir -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Copy database initialization script
COPY tools/init_db.sh /usr/local/bin/init_db.sh

# Make script executable
RUN chmod +x /usr/local/bin/init_db.sh

# Expose MariaDB port (internal only)
EXPOSE 3306

# Start MariaDB using the init script
ENTRYPOINT ["/usr/local/bin/init_db.sh"]

