# https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile

FROM senasi/php:7.3.10

ENV NGINX_VERSION=1.17.2 \
	PKG_RELEASE=1

RUN set -x \
	&& addgroup -g 101 -S nginx \
	&& adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
	&& nginxPackages=" \
		nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
	" \
	# add certificate
	&& curl -o /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
	# add repo
	&& printf "%s%s%s\n" \
        "http://nginx.org/packages/mainline/alpine/v" \
		`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
		"/main" \
		| tee -a /etc/apk/repositories \
	# add packages
	&& apk add --no-cache $nginxPackages \
	# remove the last line with the packages repos in the repositories file
	&& sed -i '$ d' /etc/apk/repositories \
	&& rm -rf /etc/apk/keys/nginx_signing.rsa.pub \
	# Bring in tzdata so users could set the timezones through the environment
	# variables
	&& apk add --no-cache tzdata \
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
