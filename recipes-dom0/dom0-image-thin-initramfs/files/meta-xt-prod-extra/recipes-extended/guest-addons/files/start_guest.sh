#!/bin/sh

#Set DEBUG to 1 in order to get debug prints
DEBUG=0

debug() {
    if [ $DEBUG -eq 1 ] ; then
        echo $@
    fi
}

debug "Waiting for backends"

check_be () {
    BE=$1
    DOMD_ID=$2
    for be in $BE
    do
        debug "process $DOMD_ID $BE"
        status=`xenstore-read /local/domain/$DOMD_ID/drivers/$be/status`
        if [ $? -eq 1 ] ; then
            return 1
        fi
        debug echo "status $status"
        if [ "$status" != "ready" ] ; then
            return 1
        fi
    done
    return 0
}

exit_function () {
    if [ -n "$XENSTORE_WATCH" ] ; then
        debug "killing xenstore-watch"
        kill $XENSTORE_WATCH
    fi
    debug "removing pipe"
    rm -rf $pipe
    exit 0
}

trap exit_function SIGINT SIGTERM

#TODO: replace following bashism with generic solution
GUEST=$1
shift
BE=$@

debug "BE = \"$BE\""

DOMD_ID=`xl domid DomD`

if [ $? -eq 1 ] ; then
    echo "DomD is not running"
    echo "Exiting"
    exit 1
fi

pipe=/tmp/${GUEST}_xenstore

if ! mkfifo $pipe ; then
    echo "Failed to create a pipe, is the script already running?"
    echo "Exiting."
    exit 1
fi

xenstore-watch /local/domain/$DOMD_ID/drivers > $pipe &
XENSTORE_WATCH=$!

debug "xenstore-watch PID $XENSTORE_WATCH"

while read event ; do
    if check_be "$BE" $DOMD_ID ; then
        xl create /xt/dom.cfg/${GUEST}.cfg
        break
    fi
done <$pipe

exit_function
