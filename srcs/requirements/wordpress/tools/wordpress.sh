#!/bin/bash

WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_REGULAR_PASSWORD=$(cat /run/secrets/wp_regular_password)
DB_PASSWORD=$(cat /run/secrets/db_password)


cd /var/www/wordpress

if [ ! -f "wp-settings.php" ]; then
    echo "Downloading WordPress..."

	#download wp
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    #download core files
    wp core download  --allow-root

	#configure wp
    wp config create \
        --dbname=${DATA_BASE} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=mariadb_1 \
        --allow-root

	wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root

	wp user create \
        ${WP_REGULAR_USER} \
        ${WP_REGULAR_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
        --allow-root
fi

exec php-fpm8.2 -F
