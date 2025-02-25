FROM debian:bookworm-slim

RUN	apt-get update && \
	apt-get install -y	\
	curl \
	mariadb-client \
	php8.2 \
	php8.2-fpm \
	php8.2-curl \
	php8.2-mysql \
	php8.2-mbstring \
	php8.2-xml \
	php8.2-zip \
	php8.2-gd \
	php8.2-imap \
	&& sed -i "s|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|g" /etc/php/8.2/fpm/pool.d/www.conf



# RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#	chmod +x wp-cli.phar && \
#    mv wp-cli.phar /usr/local/bin/wp

# COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh", "php-fpm8.2", "-F"]

