FROM debian:bookworm

RUN apt update && apt install -y \
    php \
    php-fpm \
    php-mysql \
    curl

RUN mkdir -p /var/www/html

RUN curl -L https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php \
    -o /var/www/html/index.php

EXPOSE 8081

CMD ["php", "-S", "0.0.0.0:8081", "-t", "/var/www/html"]
