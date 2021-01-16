#!/bin/sh

set -e

# running php-fpm
if [ "$1" = "php-fpm" ]; then
	if [ -e /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ]; then
    { \
      echo "[Xdebug]"; \
      echo "xdebug.mode=develop,debug,profile,trace,gcstats"; \
      echo "xdebug.start_with_request=trigger"; \
      if [ -z "${XDEBUG_CLIENT_HOST}" ]; then \
        echo "xdebug.discover_client_host=true"; \
      else \
        echo "xdebug.client_host=${XDEBUG_CLIENT_HOST}"; \
      fi; \
      echo "xdebug.client_port = ${XDEBUG_CLIENT_PORT:-9003}"; \
      echo "xdebug.output_dir=/data/log"; \
      echo "xdebug.idekey = \"${XDEBUG_IDE_KEY:-PHPSTORM}\""; \
    } | tee /usr/local/etc/php/conf.d/xdebug.ini
	fi
fi
