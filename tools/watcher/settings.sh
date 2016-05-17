#!/bin/sh

export WATCHER_DIR=$(dirname $(readlink -f $0))
export WATCH_DATA_DIR=/tmp/watcher
export WATCH_LOG="${WATCH_DATA_DIR}/sync.log"
export PID_FILE="${WATCH_DATA_DIR}/sync.pid"
