#!/bin/sh

. $(dirname $(readlink -f $0))/settings.sh

SYNC_ACTION="${WATCHER_DIR}/sync.sh"
WATCHER="${WATCHER_DIR}/watch.sh"

mkdir -p ${WATCH_DATA_DIR} || exit 1

if [ ! -d "${APP_SOURCE}" ] || [ ! -r "${APP_SOURCE}" ]; then
    echo "! Application source not found, not mounted or no read access: ${APP_SOURCE}"
    exit 1
fi

if [ ! -d "${PROJECT_ROOT}" ] || [ ! -w "${PROJECT_ROOT}" ]; then
    echo "! Application root not found or no write access: ${PROJECT_ROOT}"
    exit 2
fi

###################################################
# cleanup PID file
###################################################
if [ -f "${PID_FILE}" ]; then
    kill $(cat "${PID_FILE}")
    rm -f "${PID_FILE}"
fi

###################################################
# first time sync
###################################################
if ! "${SYNC_ACTION}"; then
    echo "*! There errors running sync action" >&2
    exit 1
fi


echo "* Watching ${APP_SOURCE}"
setsid "${WATCHER}" "${APP_SOURCE}" "${SYNC_ACTION}" > "${WATCH_LOG}" 2>&1 < /dev/null &
echo $! > ${PID_FILE}

exit 0
