FROM php:8-fpm-alpine

ARG APP_ENV

# install required php extensions
RUN if [ "$APP_ENV" = "local" ]; then apk add --no-cache $PHPIZE_DEPS && pecl install xdebug && docker-php-ext-enable xdebug; fi

RUN if [ "$APP_ENV" = "local" ]; then { \
  echo "xdebug.mode=debug"; \
  echo "xdebug.client_host = host.docker.internal"; \
  echo "xdebug.client_port = 9003"; \
  echo "xdebug.start_with_request = yes";\
  echo "xdebug.output_dir = /tmp/grinds"; \
} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; fi
