#!/bin/sh

function endless_copy {
    while :
    do
        dd if=$1 of=$2 bs=512
        rm $2
    done
}

endless_copy /dev/xvda1 /home/root/test1.img &
endless_copy /dev/xvda2 /home/root/test2.img &
