#!/bin/sh

function endless_uptime {
    while :
    do
        uptime
        sleep 1m
    done
}

endless_uptime &
