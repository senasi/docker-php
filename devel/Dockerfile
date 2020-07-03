FROM senasi/php:7.4.7

RUN	apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
	pecl install xdebug-2.9.0 && \
	docker-php-ext-enable xdebug && \
	apk del .phpize-deps-configure

RUN wget https://getcomposer.org/installer -O - -q | php -- --install-dir=/usr/local/bin --filename=composer && \
	apk add --no-cache git openssh perl && \
	composer global require friendsofphp/php-cs-fixer

ENV PATH="${PATH}:/root/.composer/vendor/bin" \
	COMPOSER_ALLOW_SUPERUSER=1

RUN apk add --no-cache nodejs npm && \
	npm install npm@latest -g && \
	npm install bower -g && \
	echo '{ "allow_root": true }' > /root/.bowerrc

WORKDIR /data
