FROM php:7.0-fpm-alpine

RUN mkdir -p /build/libiconv

COPY libiconv.patch /build/libiconv/

# iconv problem
# https://github.com/docker-library/php/issues/240
# in the future try: RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv

RUN apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS && \
    cd /build/libiconv && \
    curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz | tar -xz --strip-components=1 && \
    patch -p1 -i libiconv.patch && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    rm -rf /build && \
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
    pecl install mongodb mailparse libsodium && \
    docker-php-ext-enable mongodb mailparse sodium && \
    docker-php-ext-install calendar gd pcntl pdo_mysql soap sockets xsl zip opcache mcrypt bcmath intl imap mysqli && \
    apk del .build-deps

ENV LD_PRELOAD /usr/local/lib/preloadable_libiconv.so

COPY docker-php-entrypoint-wrapper /usr/local/bin/

ENTRYPOINT ["docker-php-entrypoint-wrapper"]
