#!/bin/sh -x

# Android partitions
# system   - xvda1
# vendor   - xvdb1
# misc     - xvdc1
# userdata - xvdd1

losetup /dev/loop0 system.raw || { echo "Failed to mount SYSTEM"; exit 1; }
losetup /dev/loop1 vendor.raw || { echo "Failed to mount VENDOR"; exit 1; }
losetup /dev/loop2 misc.raw || { echo "Failed to mount MISC"; exit 1; }
losetup /dev/loop3 userdata.raw || { echo "Failed to mount USERDATA"; exit 1; }
