FROM php:7.4.7-fpm-alpine3.12

# iconv problem
# https://github.com/docker-library/php/issues/240
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

COPY docker-php-entrypoint-wrapper /usr/local/bin/

RUN apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
	apk add --no-cache --virtual .run-deps \
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
	docker-php-ext-enable mongodb mailparse && \
	docker-php-ext-install calendar gd pcntl pdo_mysql soap sockets xsl zip opcache bcmath intl imap mysqli && \
	apk del .build-deps && \
	rm -rf /tmp/* && \
	chmod +x /usr/local/bin/docker-php-entrypoint-wrapper

ENTRYPOINT ["docker-php-entrypoint-wrapper"]

CMD "php-fpm"
