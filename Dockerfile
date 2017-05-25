FROM php:7.0-apache

ARG GITHUB_OAUTH_TOKEN

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libicu-dev \
        libcurl4-gnutls-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt intl pdo pdo_mysql curl zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && apt-get purge -y libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libicu-dev \
        libcurl4-gnutls-dev \
    && apt-get clean \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && if [ ! -z ${GITHUB_OAUTH_TOKEN} ]; then composer config -g github-oauth.github.com  $GITHUB_OAUTH_TOKEN ; fi \
    && COMPOSER_ALLOW_SUPERUSER=1 composer global require fxp/composer-asset-plugin
COPY ./ /var/www/html/
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader