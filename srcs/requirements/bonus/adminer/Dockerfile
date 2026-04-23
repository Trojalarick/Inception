FROM debian:trixie

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Download Adminer
RUN wget https://www.adminer.org/latest.php -O index.php

# Fix php-fpm port
RUN sed -i "s|listen = .*|listen = 9001|" /etc/php/8.4/fpm/pool.d/www.conf

EXPOSE 9001

CMD ["php-fpm8.4", "-F"]
