#!/bin/sh

set -e

# running php-fpm
if [ "$1" = "php-fpm" ]; then
	{ \
		echo "[www]"; \
		echo "pm = ${FPM_PM:-static}"
		echo "pm.max_children = ${FPM_MAX_CHILDREN:-2}"; \
		echo "pm.start_servers = ${FPM_START_SERVERS:-2}"; \
		echo "pm.min_spare_servers = ${FPM_MIN_SPARE_SERVERS:-2}"; \
		echo "pm.max_spare_servers = ${FPM_MAX_SPARE_SERVERS:-10}"; \
		echo "pm.max_requests = ${FPM_MAX_REQUESTS:-100}"; \
	} | tee /usr/local/etc/php-fpm.d/zzz-docker.conf

	{ \
		echo "[php]"; \
		echo "expose_php = off"; \
		echo "memory_limit = ${PHP_MEMORY_LIMIT:-512M}"; \
		echo "post_max_size = ${PHP_POST_MAX_SIZE:-256M}"; \
		echo "upload_max_filesize = ${PHP_UPLOAD_MAX_SIZE:-128M}"; \
	} | tee /usr/local/etc/php/php.ini
fi
