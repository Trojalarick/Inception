FROM debian:trixie

RUN apt-get update && apt-get install -y php-redis

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Fix php-fpm to listen on port 9000
RUN sed -i "s|listen = .*|listen = 9000|" /etc/php/8.4/fpm/pool.d/www.conf

# Create required runtime dir
RUN mkdir -p /run/php

# Set working directory
WORKDIR /var/www/html

# Download WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm8.4", "-F"]