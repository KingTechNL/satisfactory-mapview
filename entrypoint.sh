#!/bin/sh

echo "Creating nginx config for: ${SCHEME}://${USER_DOMAIN}"
envsubst '$USER_DOMAIN,$SCHEME,$SAVE_NAME' < /nginx.conf.tmpl > /etc/nginx/nginx.conf

echo "Setting symlink name to '${SAVE_NAME}'"
envsubst '$SAVE_NAME' < /update-save.sh.tmpl > /update-save.sh
chmod +x /update-save.sh

echo "Starting cron..."
cron

echo "Starting nginx container."
/docker-entrypoint.sh "$@"