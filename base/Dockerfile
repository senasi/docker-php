FROM php:8.2.11-fpm-alpine3.18

COPY docker-php-entrypoint /usr/local/bin/

COPY docker-php-entrypoint.d/ /docker-php-entrypoint.d/

RUN apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
	apk add --no-cache --virtual .run-deps \
		libsodium \
		icu-libs \
    	# https://github.com/dotnet/dotnet-docker/issues/3844
    	icu-data-full \
		openssl \
		zlib \
		libzip \
		libxslt \
		libxml2 \
		freetype \
		libwebp \
		libjpeg \
		libpng \
		c-client \
		libgcrypt && \
	apk add --no-cache --virtual .build-deps \
		bash \
		libsodium-dev \
		icu-dev \
		openssl-dev \
		zlib-dev  \
		libzip-dev  \
		libxslt-dev \
		libxml2-dev \
		freetype-dev \
		libwebp-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		imap-dev \
		libgcrypt-dev \
    	linux-headers && \
	docker-php-ext-configure gd  --with-jpeg --with-freetype --with-webp && \
	PHP_OPENSSL=yes docker-php-ext-configure imap --with-imap-ssl && \
    # latest version of mongodb ext to support mongo 3.2
	pecl install mongodb-1.12.1 mailparse && \
	# install apcu with enter on prompt about debugging
	printf "\n" | pecl install apcu && \
	docker-php-ext-enable apcu mongodb mailparse opcache && \
	docker-php-ext-install calendar gd pcntl pdo_mysql soap xsl zip bcmath intl imap mysqli sockets && \
	apk del .build-deps && \
	rm -rf /tmp/* && \
	chmod +x /usr/local/bin/docker-php-entrypoint
