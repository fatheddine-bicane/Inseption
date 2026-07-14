FROM debian:trixie

RUN apt-get update -y && apt-get upgrade -y \
	&& apt-get install curl php8.2-fpm php8.2-mysql mariadb-client -y

RUN mkdir -p /var/www/wordpress && mkdir -p /run/php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY ./tools/wordpress.sh /usr/local/bin/wordpress.sh
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /usr/local/bin/wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]
