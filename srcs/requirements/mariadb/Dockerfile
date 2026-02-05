# #Alpine = a very small Linux operating system
# #3.18 = the version

# #“Start building my image from Alpine Linux version 3.18.”

# FROM alpine:3.18 

# RUN apk update && apk add nginx

# COPY conf/nginx.conf /etc/nginx/nginx.conf


FROM alpine:3.18

# Install MariaDB
RUN apk update && apk add mariadb mariadb-client

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

