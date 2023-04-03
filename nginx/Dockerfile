# https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile

FROM senasi/php:8.2.4

ENV NGINX_VERSION=1.23.4 \
	PKG_RELEASE=1

COPY bin/ /usr/local/bin/

COPY docker-php-entrypoint.d/ /docker-php-entrypoint.d/

RUN set -x \
	&& addgroup -g 101 -S nginx \
	&& adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
	&& nginxPackages=" \
		nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
	" \
	# add certificate
	&& curl -o /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    # install from repo
    && apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
    # remove certificate
	&& rm -rf /etc/apk/keys/nginx_signing.rsa.pub \
    # Bring in gettext so we can get `envsubst`, then throw the rest away. To do this, we need to install `gettext`
    # then move `envsubst` out of the way so `gettext` can be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
	# Bring in tzdata so users could set the timezones through the environment
	# variables
	&& apk add --no-cache tzdata \
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
    # remove default config
    && rm -rf /etc/nginx/conf.d/* \
    && chmod +x /usr/local/bin/docker-nginx

COPY nginx.conf /etc/nginx/
