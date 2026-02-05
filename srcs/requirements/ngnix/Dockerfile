# Use the official NGINX image as the base
FROM alpine:3.18

RUN apk add nginx openssl
# Copy custom configuration file (if needed)

RUN   -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld

COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]

