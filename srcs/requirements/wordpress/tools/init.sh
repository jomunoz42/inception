#!/bin/bash
set -e

mkdir -p /var/www/html

cd /var/www/html

if [ ! -f wp-config.php ]; then

    echo "Downloading WP-CLI..."

    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    chmod +x wp-cli.phar

    mv wp-cli.phar /usr/local/bin/wp

    echo "Downloading WordPress..."

    wp core download --allow-root

    echo "Creating wp-config..."

    wp config create \
        --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306

    echo "Installing WordPress..."

    wp core install \
        --allow-root \
        --url=${DOMAIN_NAME} \
        --title=inception \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    wp user create \
        --allow-root \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD}
fi

echo "Starting php-fpm..."

exec /usr/sbin/php-fpm8.2 -F
