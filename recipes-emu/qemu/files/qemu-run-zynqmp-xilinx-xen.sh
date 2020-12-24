#!/bin/sh
#
# Based on: https://github.com/edgarigl/linux.git
#
# Copyright (C) 2020  Edgar E. Iglesias <edgar.iglesias@xilinx.com>
# Copyright (C) 2020 EPAM Systems Inc.
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

set -x

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

PCIE="-device xlnx-pcie-rp,bus=pcie.0,id=pcie.1,port=1,chassis=1 -device pci-bridge,addr=00.0,bus=pcie.1,id=pcie.2,chassis_nr=2 -netdev user,id=hostnet1,net=10.0.3.0/24 -device rtl8139,bus=pcie.2,addr=01.0,netdev=hostnet1,romfile="

RESET_APU="-device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4"

${QEMU} -M arm-generic-fdt,linux=on -m 2G -hw-dtb ${HW_DTB}	\
	-dtb ${DTB}						\
	-serial mon:stdio					\
	-display none						\
	-kernel ${XEN}						\
	-device loader,file=${KERNEL},addr=0x40000000		\
	-nic user -nic user -nic user				\
	-nic user,hostfwd=tcp:127.0.0.1:2222-:22		\
	-drive file=${QEMU_DOM0_ROOTFS},format=raw,id=sata-drive-dom0 \
	-device ide-hd,drive=sata-drive-dom0,bus=ahci@0xFD0C0000.0 \
	-drive file=${QEMU_DOMU_ROOTFS},format=raw,id=sata-drive-domu \
	-device ide-hd,drive=sata-drive-domu,bus=ahci@0xFD0C0000.1 \
	${PCIE}							\
	${GIC_SETUP}						\
	${RESET_APU}						\
	$*

