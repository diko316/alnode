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

exit 0
