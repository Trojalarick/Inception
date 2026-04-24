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

RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Install Redis plugin ONLY (no forcing)
RUN curl -L -o redis-cache.zip https://downloads.wordpress.org/plugin/redis-cache.latest-stable.zip \
    && unzip redis-cache.zip \
    && mv redis-cache wp-content/plugins/ \
    && rm redis-cache.zip

RUN sed -i "s|listen = .*|listen = 9000|" /etc/php/8.4/fpm/pool.d/www.conf

RUN chown -R www-data:www-data /var/www/html

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

CMD ["/setup.sh"]