ARG PHP_VERSION=8.1.3

FROM php:${PHP_VERSION}-fpm-alpine AS app_php

RUN docker-php-source extract \
    && apk add --update --virtual .build-deps autoconf g++ make pcre-dev icu-dev openssl-dev libxml2-dev libmcrypt-dev libpng-dev git \
    && apk add postgresql-dev \
    && docker-php-ext-install pgsql pdo_pgsql \
    && apk del postgresql-libs libsasl db \
    && pecl install apcu xdebug \
    && docker-php-ext-enable apcu opcache \
    && apk add icu-libs icu \
    && docker-php-ext-install intl \
# post run
    && runDeps="$( \
      scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .app-phpexts-rundeps $runDeps \
    && pecl clear-cache \
    && docker-php-source delete \
    && apk del --purge .build-deps \
    && rm -rf /tmp/pear \
    && rm -rf /var/cache/apk/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY docker/dev/php/php.ini $PHP_INI_DIR/conf.d/php.ini
COPY docker/dev/php/php-cli.ini $PHP_INI_DIR/conf.d/php-cli.ini

WORKDIR /app

COPY composer.json composer.lock symfony.lock ./
RUN set -eux; \
    composer install --prefer-dist --no-autoloader --no-scripts --no-progress --no-suggest; \
    composer clear-cache

RUN set -eux \
    && mkdir -p var/cache var/log \
    && composer dump-autoload --classmap-authoritative

VOLUME var
VOLUME vendor

COPY docker/dev/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
