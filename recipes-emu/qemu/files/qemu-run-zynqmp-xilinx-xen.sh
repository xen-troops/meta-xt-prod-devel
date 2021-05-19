#!/bin/bash
#
# Based on: https://github.com/edgarigl/linux.git
#
# Copyright (C) 2020  Edgar E. Iglesias <edgar.iglesias@xilinx.com>
# Copyright (C) 2020-2021 EPAM Systems Inc.
#
# Build Xilinx QEMU.
# Build Xilinx QEMU device-trees.
# Edit the QEMU and HW_DTB varialbes in this script.
#
# Copy the config-zynqmp-pcie into .config
# Build the kernel
# Create your rootfs named zu-rootfs.cpio.gz
# Run this script
#

DEPLOY_DIR="REPLACE_DEPLOY_DIR"

QEMU=${DEPLOY_DIR}/emu/qemu-xilinx/aarch64-softmmu/qemu-system-aarch64
HW_DTB=${DEPLOY_DIR}/emu/qemu-devicetrees/LATEST/SINGLE_ARCH/zcu102-arm.dtb

XEN=${DEPLOY_DIR}/domd-image-weston/images/salvator-x-h3-4x2g-xt/xen-salvator-x-h3-4x2g-xt
KERNEL=${DEPLOY_DIR}/dom0-image-thin-initramfs/images/generic-armv8-xt/Image
DTB=${DEPLOY_DIR}/dom0-image-thin-initramfs/images/generic-armv8-xt/zynqmp-zcu102-rev1.0.dtb
QEMU_DOM0_ROOTFS=${DEPLOY_DIR}/dom0-image-thin-initramfs/images/generic-armv8-xt/core-image-thin-initramfs-generic-armv8-xt.ext4
QEMU_DOMU_ROOTFS=${DEPLOY_DIR}/domu-image-weston/images/salvator-x-h3-4x2g-xt/core-image-weston-salvator-x-h3-4x2g-xt.ext4

# Pending a fix in QEMU.
GIC_SETUP="-device loader,addr=0xf902f000,data=0x000001e9,data-len=4,attrs-secure=on"

# eth0 is for the built-in Ethernet: macb ff0e0000.ethernet
NET_SOC="-nic user -nic user -nic user \
	-nic user,hostfwd=tcp:127.0.0.1:2222-:22"

RESET_APU="-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4"

DBG=""

options=$(getopt -o "" -l "config:,trace" -- "$@")
[ $? -eq 0 ] || {
    exit 1
}
eval set -- "$options"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --config)
            PCI_CFG_FILE=$2
            shift 2
            ;;
	--trace)
	    DBG="-D qemu_trace.log -d guest_errors -trace events=trace_events.txt"
	    shift 1
	    ;;
        *)
            break
            ;;
    esac
done

if [ -z "${PCI_CFG_FILE}" ] || [ ! -f ${PCI_CFG_FILE} ] ; then
    echo "Please provide valid configuration file with --config option if you don't want the defaults"
    DEV_PCIE="-device rtl8139,bus=pcie.2,addr=02.0,netdev=hostnet1,romfile= \
              -device rtl8139,bus=pcie.2,addr=03.0,netdev=hostnet2,romfile= \
              -netdev user,id=hostnet1,net=10.0.3.0/24 \
              -netdev user,id=hostnet2,net=10.0.4.0/24"
else
    source ${PCI_CFG_FILE}
fi

if [ -z "${PCI_BRIDGE_ADDRESS}" ] ; then
    PCI_BRIDGE_ADDRESS="00.0"
fi

PCIE_BASE="-device xlnx-pcie-rp,bus=pcie.0,id=pcie.1,port=1,chassis=1 \
           -device pci-bridge,addr=${PCI_BRIDGE_ADDRESS},bus=pcie.1,id=pcie.2,chassis_nr=2"

echo "################################################################################"
echo "# PCI config:      $PCIE_BASE"
echo "#                  $DEV_PCIE"
echo "# QEMU binary:     $QEMU"
echo "# Xen:             $XEN"
echo "# Domian-0 Linux:  $KERNEL"
echo "# Domain-0 rootfs: $QEMU_DOM0_ROOTFS"
echo "# DomU rootfs:     $QEMU_DOMU_ROOTFS"
echo "################################################################################"
echo "# Use Ctrl-a x to terminate QEMU"
echo "# Use Ctrl-a c to enter/exit QEMU's monitor"
echo "# Use ssh root@localhost -p 2222 to connect to Domain-0"
echo "################################################################################"
echo "# Pass \"trace\" as the very first command line argument to run with traces"
echo "################################################################################"


${QEMU} -M arm-generic-fdt,linux=on -m 2G -hw-dtb ${HW_DTB}	\
	-dtb ${DTB}						\
	-serial mon:stdio					\
	-display none						\
	-kernel ${XEN}						\
	-device loader,file=${KERNEL},addr=0x40000000		\
	-drive file=${QEMU_DOM0_ROOTFS},format=raw,id=sata-drive-dom0 \
	-device ide-hd,drive=sata-drive-dom0,bus=ahci@0xFD0C0000.0 \
	-drive file=${QEMU_DOMU_ROOTFS},format=raw,id=sata-drive-domu \
	-device ide-hd,drive=sata-drive-domu,bus=ahci@0xFD0C0000.1 \
	${PCIE_BASE}						\
	${DEV_PCIE}						\
	${GIC_SETUP}						\
	${RESET_APU}						\
	${NET_SOC}						\
	${DBG}
