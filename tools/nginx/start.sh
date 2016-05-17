#!/bin/sh


MAIN_CONF="${PROJECT_ROOT}/nginx.conf"
MAIN_CONF_FILE=/etc/nginx/conf/nginx.conf

APP_CONF="${PROJECT_ROOT}/app.conf"
CONF_DIR=/etc/nginx/conf/conf.d
APP_CONF_FILE="${CONF_DIR}/app.conf"

nginx -s stop > /dev/null 2>&1 || true


if [ -f "${MAIN_CONF}" ] && [ -w "${MAIN_CONF_FILE}" ]; then
    rm "${MAIN_CONF_FILE}"
    echo "Using your Nginx config: ${MAIN_CONF}"
    ln -s "${MAIN_CONF}" "${MAIN_CONF_FILE}" || exit 1
fi

if [ -f "${APP_CONF}" ] && [ -d "${CONF_DIR}" ] && [ -w "${CONF_DIR}" ]; then
    # remove if exist
    [ -f "${APP_CONF_FILE}" ] && rm -Rf ${CONF_DIR}/app.conf

    echo "Using your Application Nginx config: ${APP_CONF}"
    ln -s "${APP_CONF}" "${APP_CONF_FILE}" || exit 2
fi


echo "Starting nginx..."
if [ "${NGINX_DAEMON}" = "true" ]; then
    nginx -s start || exit 1
else
    nginx -g 'daemon off;' || exit 1
fi

exit 0
