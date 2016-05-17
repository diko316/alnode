#!/bin/sh

export INSTALLER_DIR=$(dirname $(readlink -fn $0))
export MODE=APK_MODE
export INSTALL_DATA_DIR=/tmp/installer
export CURRENT_CWD=$(pwd)
export USE_BUILD_TOOLS=
export APK_PERMANENT_FILE="${INSTALL_DATA_DIR}/apk_permanent.tab"
export APK_VOLATILE_FILE="${INSTALL_DATA_DIR}/apk.tab"
export BUILDERS_FILE="${INSTALL_DATA_DIR}/custom_builders.tab"
export NPM_GLOBAL_PERMANENT_FILE="${INSTALL_DATA_DIR}/npm_global_permanent.tab"
export NPM_GLOBAL_VOLATILE_FILE="${INSTALL_DATA_DIR}/npm_global.tab"
export NPM_PERMANENT_FILE="${INSTALL_DATA_DIR}/npm_permanent.tab"
export NPM_VOLATILE_FILE="${INSTALL_DATA_DIR}/npm.tab"
