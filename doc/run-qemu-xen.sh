#!/bin/bash -e
# Based on:
# https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions/qemu-system-aarch64

################################################################################
# Configuration
################################################################################
QEMU_EFI_URL=http://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/3992/QEMU-AARCH64/RELEASE_CLANG35/
QEMU_EFI_NAME=QEMU_EFI.fd

GEN_DIR=generated

QEMU_EFI_VOL0=${GEN_DIR}/flash0_boot.img
QEMU_EFI_VOL1=${GEN_DIR}/flash1_nvram.img
QEMU_EFI_BOOT_VOL=${GEN_DIR}/efi.vfat
QEMU_BOOT_CFG=${GEN_DIR}/bootaa64.cfg

QEMU_DOM0_DTB=${GEN_DIR}/virt-gicv3.dtb

source run-qemu-xen.cfg

################################################################################
# Run-time
################################################################################
QEMU_EFI_IMG_NAME=${GEN_DIR}/${QEMU_EFI_NAME}

run_download_bins()
{
    # Load the QEMU EFI loader
    if [ ! -f ${QEMU_EFI_IMG_NAME} ]; then
        curl -o ${QEMU_EFI_IMG_NAME} \
           -OL ${QEMU_EFI_URL}/${QEMU_EFI_NAME}
    fi
}

QEMU_CMD_LINE="\
   -machine type=virt \
   -machine virt,gic_version=2 \
   -machine virtualization=true \
   -cpu cortex-a57 \
   -smp ${QEMU_NCPU} \
   -m ${QEMU_MEM_SZ} \
   -nic user,hostfwd=tcp:127.0.0.1:2222-:22 \
   -nographic \
   -serial mon:stdio \
   -drive file=${QEMU_EFI_VOL0},format=raw,if=pflash \
   -drive file=${QEMU_EFI_VOL1},format=raw,if=pflash \
"

run_generate_dtb()
{
   if [ ! -f ${QEMU_DOM0_DTB} ]; then
      echo "Generating device tree blob ${QEMU_DOM0_DTB}"
      ${QEMU_BIN} ${QEMU_CMD_LINE} \
         -machine dumpdtb=${QEMU_DOM0_DTB}
   fi
}

run_generate_efi_vols()
{
   if [ ! -f ${QEMU_EFI_VOL0} ]; then
      echo "Generating EFI volume (boot) ${QEMU_EFI_VOL0}"
      dd if=/dev/zero of=${QEMU_EFI_VOL0} bs=1M count=64
      dd if=${QEMU_EFI_IMG_NAME} of=${QEMU_EFI_VOL0} conv=notrunc
   fi
   if [ ! -f ${QEMU_EFI_VOL1} ]; then
      echo "Generating EFI volume (NVRAM) ${QEMU_EFI_VOL1}"
      dd if=/dev/zero of=${QEMU_EFI_VOL1} bs=1M count=64
   fi
}

run_generate_efi_vfat()
{
   rm -f ${QEMU_EFI_BOOT_VOL} || true
   mkfs.vfat -C ${QEMU_EFI_BOOT_VOL} 128000
   mmd -i ${QEMU_EFI_BOOT_VOL} ::EFI
   mmd -i ${QEMU_EFI_BOOT_VOL} ::EFI/BOOT
   mcopy -i ${QEMU_EFI_BOOT_VOL} ${XEN_PATH}/xen/xen.efi ::EFI/BOOT/bootaa64.efi
   mcopy -i ${QEMU_EFI_BOOT_VOL} ${LINUX_PATH}/arch/arm64/boot/Image ::EFI/BOOT/kernel
   mcopy -i ${QEMU_EFI_BOOT_VOL} ${QEMU_DOM0_DTB} ::EFI/BOOT/virt-gicv3.dtb
   echo "options=console=dtuart noreboot dom0_mem=512M loglvl=all" > ${QEMU_BOOT_CFG}
   echo "kernel=kernel root=/dev/vda rw console=hvc0" >> ${QEMU_BOOT_CFG}
   echo "dtb=virt-gicv3.dtb" >> ${QEMU_BOOT_CFG}
   mcopy -i ${QEMU_EFI_BOOT_VOL} ${QEMU_BOOT_CFG} ::EFI/BOOT/bootaa64.cfg
}

run_qemu()
{
   # Order matters: EFI boot volume should be the first
   # (otherwise change the boot device in UEFI's menu),
   # domu, then dom0
   ${QEMU_BIN} ${QEMU_CMD_LINE} \
      -drive if=none,file=${QEMU_EFI_BOOT_VOL},id=hd0,format=raw \
      -device virtio-blk-device,drive=hd0 \
      -drive if=none,file=${QEMU_DOMU_ROOTFS},id=domu,format=raw \
      -device virtio-blk-device,drive=domu \
      -drive if=none,file=${QEMU_DOM0_ROOTFS},id=dom0,format=raw \
      -device virtio-blk-device,drive=dom0 \
      -device igb
}

echo "################################################################################"
echo "# Build QEMU with:"
echo "#   ./configure --target-list=aarch64-softmmu"
echo "#   make"
echo "################################################################################"
echo "# Build Xen with:"
echo "#   ./configure \$CONFIGURE_FLAGS"
echo "#   make"
echo "################################################################################"
echo "# Build kernel with:"
echo "#   make defconfig"
echo "#   make"
echo "################################################################################"
echo "# To mount/umount domain's rootfs:"
echo "# udisksctl loop-setup -f $QEMU_DOM0_ROOTFS"
echo "# umount /dev/loop3"
echo "# udisksctl loop-delete -b /dev/loop3"
echo "################################################################################"
echo "# QEMU binary:     $QEMU_BIN"
echo "# Xen:             $XEN_PATH"
echo "# Domian-0 Linux:  $LINUX_PATH"
echo "# Domain-0 rootfs: $QEMU_DOM0_ROOTFS"
echo "# DomU rootfs:     $QEMU_DOMU_ROOTFS"
echo "################################################################################"
echo "# Use Ctrl-A X to terminate QEMU"
echo "# Use Ctrl-A C to enter QEMU's monitor"
echo "# Use ssh root@localhost -p 2222 to connect to Domain-0"
echo "################################################################################"

echo
read -t 3 -p "Starting in 3 seconds or press ENTER now" || true
echo

mkdir ${GEN_DIR} 2>/dev/null || true

run_download_bins
run_generate_efi_vols
run_generate_dtb
run_generate_efi_vfat
run_qemu
