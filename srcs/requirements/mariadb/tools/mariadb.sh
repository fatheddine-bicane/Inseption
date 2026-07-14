#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)

if [ ! -d "/var/lib/mysql/$DATA_BASE" ]; then
    service mariadb start
    mariadb -e "CREATE DATABASE $DATA_BASE;"
    mariadb -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
    mariadb -e "GRANT ALL PRIVILEGES ON $DATA_BASE.* TO '$DB_USER';"
    service mariadb stop
fi

exec mariadbd
