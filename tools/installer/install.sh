#!/bin/sh

. $(dirname $(readlink -fn $0))/settings.sh

if [ -d "${PROJECT_ROOT}" ]; then
    NPM_PACKAGE_FILE="${PROJECT_ROOT}/package.json"
    BOWER_PACKAGE_FILE="${PROJECT_ROOT}/bower.json"
fi


#####################################################
# Initialize stuffs to install
#####################################################
mkdir -p ${INSTALL_DATA_DIR} > /dev/null || exit 1

if [ -d "${INSTALL_DATA_DIR}" ]; then
    rm -Rf ${INSTALL_DATA_DIR}/*.tab || true
fi

while [ $# -gt 0 ]; do
    ARG=$1
    shift 1
    case "${ARG}" in
    "--apk-permanent")
        MODE=APK_PERMANENT_MODE
        ;;
    "--apk")
        MODE=APK_MODE
        ;;
    "--builder")
        MODE=BUILD_MODE
        ;;
    "--npm-global-permanent")
        MODE=NPM_GLOBAL_PERMANENT_MODE
        ;;
    "--npm-global")
        MODE=NPM_GLOBAL_MODE
        ;;
    "--build-tools")
        USE_BUILD_TOOLS=true
        ;;
    "--no-cleanup")
        NO_CLEANUP=true
        ;;
    *)
        case "${MODE}" in
        "APK_PERMANENT_MODE")
            touch ${APK_PERMANENT_FILE}
            echo "${ARG}" >> ${APK_PERMANENT_FILE}
            ;;
        "APK_MODE")
            touch ${APK_VOLATILE_FILE}
            echo "${ARG}" >> ${APK_VOLATILE_FILE}
            ;;
        "BUILD_MODE")
            touch ${BUILDERS_FILE}
            echo "${ARG}" >> ${BUILDERS_FILE}
            ;;
        "NPM_GLOBAL_PERMANENT_MODE")
            touch ${NPM_GLOBAL_PERMANENT_FILE}
            echo "${ARG}" >> ${NPM_GLOBAL_PERMANENT_FILE}
            ;;
        "NPM_GLOBAL_MODE")
            touch ${NPM_GLOBAL_VOLATILE_FILE}
            echo "${ARG}" >> ${NPM_GLOBAL_VOLATILE_FILE}
            ;;
        esac
        ;;
    esac
done

#####################################################
# Pre install
#####################################################
if [ -f "${BOWER_PACKAGE_FILE}" ] || [ -f "${NPM_PACKAGE_FILE}" ] || [ -f "${NPM_GLOBAL_PERMANENT_MODE}" ] || [ -f "${NPM_GLOBAL_MODE}" ] || [ "${USE_BUILD_TOOLS}" = "true" ]; then

    # must install build tools
    printf '%s\n%s\n%s\n%s\n%s\n%s\n'\
			python \
			linux-headers \
			paxctl \
			libgcc \
			libstdc++ \
			build-base >> ${APK_VOLATILE_FILE}

    if [ -f "${BOWER_PACKAGE_FILE}" ]; then
        echo "bower" >> ${NPM_GLOBAL_VOLATILE_FILE}
    fi

fi

#####################################################
# Install Apk packages
#####################################################
# volatile
if [ -f "${APK_VOLATILE_FILE}" ]; then
    cat "${APK_VOLATILE_FILE}" | xargs -r -t apk add --no-cache || exit 2
fi

# permanent
if [ -f "${APK_PERMANENT_FILE}" ]; then
    cat "${APK_PERMANENT_FILE}" | xargs -r -t apk add --no-cache || exit 2
fi

#####################################################
# Install GLOBAL NPM packages
#####################################################
# volatile
if [ -f "${NPM_GLOBAL_VOLATILE_FILE}" ]; then
    cat "${NPM_GLOBAL_VOLATILE_FILE}" | xargs -r -t npm install -g -y -dd || ex$
fi

# permanent
if [ -f "${NPM_GLOBAL_PERMANENT_FILE}" ]; then
    cat "${NPM_GLOBAL_PERMANENT_FILE}" | xargs -r -t npm install -g -y -dd || exit 3
fi


#####################################################
# Install LOCAL NPM packages
#####################################################
if [ -d "${PROJECT_ROOT}" ] && [ -w "${PROJECT_ROOT}" ]; then
    cd "${PROJECT_ROOT}"

    # install APP specific
    if [ -f "${NPM_PACKAGE_FILE}" ]; then
        npm install -y -dd || exit 4
    fi

    # install BOWER modules
    if [ -f "${BOWER_PACKAGE_FILE}" ]; then
        bower install -V --config.interactive=false --allow-root || exit 4
    fi

    cd "${CURRENT_CWD}"
fi

if [ -f "${BUILDERS_FILE}" ]; then
    while read RUN; do
        echo "* Running Build Script: ${RUN}"
        ${RUN} || exit 5
    done < "${BUILDERS_FILE}"
fi



#####################################################
# Cleanup
#####################################################
if [ ! "${NO_CLEANUP}" ]; then
    ${INSTALLER_DIR}/install-cleanup.sh || exit 6
fi

exit 0
