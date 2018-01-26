#!/bin/sh

#dhclient eth0
brctl addbr xenbr0
brctl stp xenbr0 off
brctl setfd xenbr0 0
brctl addif xenbr0 eth0
ifconfig eth0 up
ifconfig xenbr0 up
dhclient xenbr0
