FROM php:7.1.27-fpm-alpine

# iconv problem
# https://github.com/docker-library/php/issues/240
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

RUN apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
	apk add --no-cache --virtual .run-deps \
		libsodium \
		icu-libs \
		openssl \
		libmcrypt \
		zlib \
		libxslt \
		libxml2 \
		freetype \
		libwebp \
		libjpeg \
		libpng \
		c-client && \
	apk add --no-cache --virtual .build-deps \
		bash \
		libsodium-dev \
		icu-dev \
		openssl-dev \
		libmcrypt-dev \
		zlib-dev  \
		libxslt-dev \
		libxml2-dev \
		freetype-dev \
		libwebp-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		imap-dev && \
	docker-php-ext-configure gd  --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ --with-webp-dir=/usr/include/ && \
	docker-php-ext-configure imap --with-imap-ssl=/usr && \
	pecl install mongodb mailparse && \
	docker-php-ext-enable mongodb mailparse && \
	docker-php-ext-install calendar gd pcntl pdo_mysql soap sockets xsl zip opcache mcrypt bcmath intl imap mysqli && \
	apk del .build-deps && \
	rm -rf /tmp/*

COPY docker-php-entrypoint-wrapper /usr/local/bin/

ENTRYPOINT ["docker-php-entrypoint-wrapper"]

CMD "php-fpm"