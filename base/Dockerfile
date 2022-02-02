FROM php:8.0.15-fpm-alpine3.15

COPY docker-php-entrypoint /usr/local/bin/

COPY docker-php-entrypoint.d/ /docker-php-entrypoint.d/

# iconv problem
# https://github.com/docker-library/php/issues/240
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

RUN apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
	apk add --no-cache --virtual .run-deps \
	    gnu-libiconv \
		libsodium \
		icu-libs \
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
		libgcrypt-dev && \
	docker-php-ext-configure gd  --with-jpeg --with-freetype --with-webp && \
	PHP_OPENSSL=yes docker-php-ext-configure imap --with-imap-ssl && \
	pecl install mongodb mailparse && \
	# install apcu with enter on prompt about debugging
	printf "\n" | pecl install apcu && \
	docker-php-ext-enable apcu mongodb mailparse && \
	docker-php-ext-install calendar gd pcntl pdo_mysql soap xsl zip opcache bcmath intl imap mysqli && \
    # workaround for sockets ext: https://github.com/docker-library/php/issues/1245
    CFLAGS="$CFLAGS -D_GNU_SOURCE" docker-php-ext-install sockets && \
	apk del .build-deps && \
	rm -rf /tmp/* && \
	chmod +x /usr/local/bin/docker-php-entrypoint
