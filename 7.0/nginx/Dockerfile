FROM nginx:1.15-alpine AS nginx

FROM senasi/php:7.0

COPY --from=nginx /usr/sbin/nginx /usr/sbin/

COPY --from=nginx /usr/lib/nginx /usr/lib/nginx/

COPY --from=nginx /etc/nginx /etc/nginx/

RUN \
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	apk add --no-cache --virtual .gettext gettext && \
	mv /usr/bin/envsubst /tmp/ && \
	apk del .gettext && \
	mv /tmp/envsubst /usr/local/bin/ && \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
		)" && \
	apk add --no-cache --virtual .nginx-rundeps $runDeps && \
	\
	# Bring in tzdata so users could set the timezones through the environment
	# variables
	apk add --no-cache tzdata && \
	\
	# create user
	addgroup -S nginx && \
	adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && \
	\
	# symbolic links for log files to stdout/stderr
	mkdir /var/log/nginx && \
	ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log
