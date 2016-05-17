#!/bin/sh

FILE=$1
[ $# -ge 1 ] && shift 1
ACTION="$*"

if ! which inotifywait > /dev/null; then
    echo "*! inotify-tools is not installed" >&2
    exit 1
fi

if [ ! "$ACTION" ]; then
    echo "*! no action defined" >&2
    exit 1
fi

trap kill_inotify 0
trap kill_inotify 1
trap kill_inotify 2
trap kill_inotify 3
trap kill_inotify 6
trap kill_inotify 15

kill_inotify() {
    if [ "${APID}" ]; then
        echo "killing action pid ${APID}"
        ls /proc | grep '^'${APID}'$' && kill ${APID} && APID=
    fi

    if [ "${PID}" ]; then
        echo "killing monitor pid ${PID}"
        ls /proc | grep '^'${PID}'$' && kill ${PID} && PID=
    fi
    echo "** End watcher..."
    exit 0
}



echo "** Running watcher..."

while true; do

    if [ -x "${ACTION}" ]; then
        ${ACTION} &
        APID=$!
        sleep 1

        if [ -d "${FILE}" ]; then
            inotifywait -q -r -e close_write,modify,move,create,delete "${FILE}" &
        else
            inotifywait -q -e close_write,modify,move,create,delete "${FILE}" &
        fi
        PID=$!
        wait $PID
        ls /proc | grep '^'${APID}'$' && kill ${APID} && APID=
        ls /proc | grep '^'${PID}'$' && kill ${PID} && PID=
    else
        echo "!* ${ACTION} is not an executable file."
        break;
    fi

done

exit 0

