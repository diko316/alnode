#!/bin/sh

echo "* Sync files from ${APP_SOURCE} to ${PROJECT_ROOT}"
if ! which rsync > /dev/null; then
    echo "*! rsync is not installed"
    exit 1
fi

if [ -d "${PROJECT_ROOT}" ]; then
    echo "* Sync changes ${APP_SOURCE} to ${PROJECT_ROOT}"
    rsync -rpDzhu \
        --exclude=".git*" \
        --exclude="*node_modules/*" \
        "${APP_SOURCE}/" "${PROJECT_ROOT}" || exit 2
else
    echo "*! ${PROJECT_ROOT} do not exist or not a directory"
    exit 2
fi

exit 0
