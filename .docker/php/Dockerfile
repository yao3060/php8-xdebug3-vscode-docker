FROM php:8-fpm-alpine

# COPY ./etc/php/php.ini $PHP_INI_DIR/
# COPY ./etc/php/xdebug.ini $PHP_INI_DIR/conf.d/

# install required php extensions
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.output_dir = /tmp/grinds" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
