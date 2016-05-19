#!/bin/sh

. $(dirname $(readlink -fn $0))/settings.sh


#####################################################
# Uninstall Apk packages
#####################################################
# volatile
if [ -f "${APK_VOLATILE_FILE}" ]; then
    cat "${APK_VOLATILE_FILE}" | xargs -r -t apk del || exit 1
fi

#####################################################
# Uninstall NPM packages
#####################################################
# volatile
if [ -f "${NPM_GLOBAL_VOLATILE_FILE}" ]; then
    cat "${NPM_GLOBAL_VOLATILE_FILE}" | xargs -r -t npm uninstall -dd -y -g || exit 1
fi

#####################################################
# Purge directories
#####################################################
rm -rf /etc/ssl \
		/usr/share/man \
		/usr/include/* \
		/tmp/* \
		/var/cache/apk/* \
		/root/.npm \
		/root/.node-gyp \
		/root/.gnupg \
		/usr/lib/node_modules/npm/man \
		/usr/lib/node_modules/npm/doc \
		/usr/lib/node_modules/npm/html > /dev/null || true


#####################################################
# Purge NPM package directories
#####################################################
rm -rf $(find "/usr/lib/node_modules" -name test -o -type d | grep '/test$') 2>/dev/null || true

# cleanup $PROJECT_ROOT/node_modules
if [ -d "${PROJECT_ROOT}/node_modules" ]; then
    rm -rf $(find "${PROJECT_ROOT}/node_modules" -name test -o -type d | grep '/test$') 2>/dev/null || true
fi

# cleanup $PROJECT_ROOT/bower_components
if [ -d "${PROJECT_ROOT}/bower_components" ]; then
    rm -rf $(find "${PROJECT_ROOT}/bower_components" -name test -o -type d | grep '/test$') 2>/dev/null || true
fi

if [ -d "/root/.node-gyp" ]; then
    rm -rf "/root/.node-gyp" 2>/dev/null || true
fi

if [ -d "/root/.cache" ]; then
    rm -rf "/root/.cache" 2>/dev/null || true
fi

if [ -d "/root/.config" ]; then
    rm -rf "/root/.config" 2>/dev/null || true
fi

if [ -d "/root/.local" ]; then
    rm -rf "/root/.local" 2>/dev/null || true
fi

if [ -d "/usr/share/doc" ]; then
    rm -rf "/usr/share/doc" 2>/dev/null || true
fi


exit 0
