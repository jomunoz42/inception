FROM debian:bookworm

RUN apt update && apt install -y \
    php-fpm \
    php-mysql \
    php-redis \
    curl \
    mariadb-client

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /run/php

COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

EXPOSE 9000

CMD ["/usr/local/bin/init.sh"]
