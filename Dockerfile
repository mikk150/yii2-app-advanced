FROM mikk150/yii2-base:latest

ARG GITHUB_OAUTH_TOKEN
ENV GITHUB_OAUTH_TOKEN=${GITHUB_OAUTH_TOKEN}

RUN if [ ! -z ${GITHUB_OAUTH_TOKEN} ]; then composer config -g github-oauth.github.com  $GITHUB_OAUTH_TOKEN ; fi \
    && COMPOSER_ALLOW_SUPERUSER=1 composer global require fxp/composer-asset-plugin
COPY ./ /var/www/html/
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader