#!/bin/sh
### BEGIN INIT INFO
# Provides: xt_set_root_dev_cfg
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
### END INIT INFO

# Change domain configuration to boot from storage configured by u-boot
DOM_CFG_DIR="/xt/dom.cfg"

# detect boot storage device
BOOT_STORAGE=`cat /proc/device-tree/boot_dev/device`
if [ -z "$BOOT_STORAGE" ] ; then
	BOOT_STORAGE=mmcblk1
	echo "WARNING! Using default storage: ${BOOT_STORAGE}"
fi

# guess partition prefix, e.g. "" for sda2 or "p" for mmcblk1p2
PART_PREFIX=""
if echo "${BOOT_STORAGE}" | grep -q 'mmc' ; then
   PART_PREFIX="p"
fi
STORAGE_PART="${BOOT_STORAGE}${PART_PREFIX}"

# now make up the configuration
echo "Mangling domain configuration: setting storage to ${BOOT_STORAGE}"
sed -i "s/STORAGE_PART/${STORAGE_PART}/g" ${DOM_CFG_DIR}/domd.cfg

if [ -f ${DOM_CFG_DIR}/domf.cfg ] ; then
    sed -i "s/STORAGE_PART/${STORAGE_PART}/g" ${DOM_CFG_DIR}/domf.cfg
fi

if [ -f ${DOM_CFG_DIR}/domu.cfg ] ; then
   sed -i "s/STORAGE_PART/${STORAGE_PART}/g" ${DOM_CFG_DIR}/domu.cfg
fi
