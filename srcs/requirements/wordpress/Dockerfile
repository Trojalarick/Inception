FROM debian:trixie

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    php-redis \
    wget \
    curl \
    unzip \
    netcat-openbsd \
    redis-tools \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

WORKDIR /var/www/html

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Install Redis plugin zip ahead of time (offline install in setup.sh)
RUN curl -L -o /tmp/redis-cache.zip https://downloads.wordpress.org/plugin/redis-cache.latest-stable.zip

RUN sed -i "s|listen = .*|listen = 9000|" /etc/php/8.4/fpm/pool.d/www.conf

RUN chown -R www-data:www-data /var/www/html

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000
CMD ["/setup.sh"]