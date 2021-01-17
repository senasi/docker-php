FROM senasi/php:8.0.1

COPY composer /usr/local/bin/

COPY docker-php-entrypoint.d/ /docker-php-entrypoint.d/

RUN	apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
	pecl install xdebug && \
	docker-php-ext-enable xdebug && \
	apk del .phpize-deps-configure && \
    # composer
    wget https://getcomposer.org/installer -O - -q | php -- --install-dir=/usr/local/bin --filename=composer-real && \
    chmod +x /usr/local/bin/composer && \
    # node + tools
	apk add --no-cache git openssh perl nodejs npm su-exec && \
	# codesniffer
	composer-real global require squizlabs/php_codesniffer phpstan/phpstan vimeo/psalm && \
    # update npm + install eslint
	npm install npm@latest eslint -g

ENV PATH="${PATH}:/root/.composer/vendor/bin" \
	COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /data
