FROM senasi/php:7.4.13

RUN	apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
	pecl install xdebug && \
	docker-php-ext-enable xdebug && \
	apk del .phpize-deps-configure

RUN wget https://getcomposer.org/installer -O - -q | php -- --install-dir=/usr/local/bin --filename=composer && \
	apk add --no-cache git openssh perl && \
	composer global require squizlabs/php_codesniffer phpstan/phpstan vimeo/psalm

ENV PATH="${PATH}:/root/.composer/vendor/bin" \
	COMPOSER_ALLOW_SUPERUSER=1

RUN apk add --no-cache nodejs npm su-exec && \
	npm install npm@latest eslint -g

WORKDIR /data
