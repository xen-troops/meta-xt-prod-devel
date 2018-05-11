#!/bin/sh

ROOTFS_TYPE=`stat -f -c %T /`
ADISKS_FOLDER="/var/run/android-disks"
RAW_FOLDER="/xt/android/"

if [ $ROOTFS_TYPE == "nfs" ]
then
# rootfs is nfs, expect Android partitions are raw files in /xt/android
    ln -s /dev/loop0 $ADISKS_FOLDER/system
    ln -s /dev/loop1 $ADISKS_FOLDER/vendor
    ln -s /dev/loop2 $ADISKS_FOLDER/misc
    ln -s /dev/loop3 $ADISKS_FOLDER/userdata

    cd $RAW_FOLDER && /xt/scripts/doma_loop_setup.sh || exit 1
else
# different block devices have different naming for partitions,
# e.g. sda will have <sda>2 while mmcblk1 will have <mmcblk1>p2
    BOOT_STORAGE=`cat /proc/cmdline | sed -e 's#^.*\broot=/dev/##' -e 's/ .*$//'`
    if [ -z "$BOOT_STORAGE" ]
    then
        BOOT_STORAGE=mmcblk1p2
        echo "WARNING! Using default for storage device: ${BOOT_STORAGE}"
    fi
   echo "Using ${BOOT_STORAGE} as boot storage device"
# get storage device name where root partition lives
    BASE_DEV=`basename "$(readlink -f "/sys/class/block/${BOOT_STORAGE}/..")"`
# get partition prefix, e.g. "" for sda2 or "p" for mmcblk1p2
    PART_PREFIX=`echo ${BOOT_STORAGE} | eval sed -e 's/${BASE_DEV}//g' | sed 's/[0-9]\+//'`
    ln -s /dev/${BASE_DEV}${PART_PREFIX}5 $ADISKS_FOLDER/system
    ln -s /dev/${BASE_DEV}${PART_PREFIX}6 $ADISKS_FOLDER/vendor
    ln -s /dev/${BASE_DEV}${PART_PREFIX}7 $ADISKS_FOLDER/misc
    ln -s /dev/${BASE_DEV}${PART_PREFIX}8 $ADISKS_FOLDER/userdata
fi

xenstore-write drivers/disks/status ready
