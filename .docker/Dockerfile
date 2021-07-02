FROM composer:2 as composer

# copy source code to image
COPY ./src/composer.json ./src/composer.lock /app/
RUN composer install --no-scripts --no-autoloader --no-dev --prefer-dist -vvv

FROM php:8-fpm-alpine as php

ARG APP_ENV
# add phpredis to php-available-exts (install in the next step)
ENV PHPREDIS_VERSION 5.3.2

# install required php extensions
RUN if [ "$APP_ENV" = "local" ]; then apk add --no-cache $PHPIZE_DEPS && pecl install xdebug && docker-php-ext-enable xdebug; fi

RUN if [ "$APP_ENV" = "local" ]; then { \
  echo "xdebug.mode=debug"; \
  echo "xdebug.client_host = host.docker.internal"; \
  echo "xdebug.client_port = 9003"; \
  echo "xdebug.start_with_request = yes";\
  echo "xdebug.output_dir = /tmp/grinds"; \
} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; fi

RUN mkdir -p /usr/src/php/ext/redis \
  && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
  && echo 'redis' >> /usr/src/php-available-exts

# install required php extensions
RUN apk add --no-cache libzip-dev  \
  && docker-php-ext-install pdo pdo_mysql opcache zip bcmath redis \
  && rm -rf /var/cache/apk/* /tmp/* \
  && docker-php-source delete

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=4000'; \
  echo 'opcache.revalidate_freq=2'; \
  echo 'opcache.fast_shutdown=1'; \
  echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# copy PHP configuration to image

# copy source code to image
COPY --from=composer /app/vendor /var/www/html/vendor
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY ./src /var/www/html

RUN /usr/bin/composer dump-autoload

# Run this after copy source to image instead of /start
RUN touch /var/www/html/storage/logs/lumen.log && \
  chown -R :www-data /var/www/html && \
  find /var/www/html -type f -exec chmod 644 {} \; && \
  find /var/www/html -type d -exec chmod 755 {} \; && \
  chmod -R 775 /var/www/html/storage  && \
  chmod +x /var/www/html/artisan

# copy start script to image
COPY ./.docker/php/start /start
COPY ./.docker/php/init /init

CMD ["/start"]


FROM nginx:1.19-alpine as nginx
# copy NGINX configuration to image
COPY .docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY .docker/nginx/snippets/cors /etc/nginx/snippets/cors

# copy src/public folder to NGINX
COPY ./src/public /var/www/html/public

# set folder permissions
RUN find /var/www/html -type d -exec chmod 755 {} \;
