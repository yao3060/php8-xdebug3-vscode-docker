FROM php:8-fpm-alpine

# COPY ./etc/php/php.ini $PHP_INI_DIR/
# COPY ./etc/php/xdebug.ini $PHP_INI_DIR/conf.d/

# install required php extensions
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug