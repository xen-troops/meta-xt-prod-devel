#!/bin/sh -x

# Android partitions
# system   - xvda1
# vendor   - xvdb1
# misc     - xvdc1
# userdata - xvdd1

losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -d /dev/loop2
losetup -d /dev/loop3

