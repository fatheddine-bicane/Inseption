#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)

service mariadb start
mariadb -u root -e "CREATE DATABASE $DATA_BASE;"
mariadb -u root -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -u root -e "GRANT ALL PRIVILEGES ON $DATA_BASE.* TO '$DB_USER';"
service mariadb stop

exec mariadbd
