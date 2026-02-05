FROM alpine:3.18
# Set environment variables for WordPress

RUN apk add php php-fpm php-mysqli curl

ENV WORDPRESS_DB_HOST=db
ENV WORDPRESS_DB_USER=root
ENV WORDPRESS_DB_PASSWORD=secure-password
ENV WORDPRESS_DB_NAME=wordpress

# Expose port 80
EXPOSE 80
