#!/bin/bash -e

source run-qemu-xilinx.cfg

export QEMU_MEM_SZ=4G

#for creating sockets and parallel communication in multi-arch
QEMU_MACH_PATH=/tmp/qemu-xilinx-machine-path0

# remove stale and create fresh
rm -rf ${QEMU_MACH_PATH}
mkdir -p ${QEMU_MACH_PATH}

ZYNQ_DTB_DIR_MARCH="${ZYNQ_DTB_DIR}/LATEST/MULTI_ARCH/"

# Start PMU emulator
${QEMU_BIN_DIR}/microblazeel-softmmu/qemu-system-microblazeel \
	-M microblaze-fdt \
	-display none \
	-device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 \
	-device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 \
	-kernel ${ZYNQ_DEPLOY_DIR}/pmu_rom_qemu_sha3.elf \
	-device loader,file=${ZYNQ_DEPLOY_DIR}/pmu-firmware-zcu102-zynqmp.elf \
	-hw-dtb ${ZYNQ_DTB_DIR_MARCH}/zynqmp-pmu.dtb \
	-machine-path ${QEMU_MACH_PATH} &

${QEMU_BIN_DIR}/aarch64-softmmu/qemu-system-aarch64 \
	-M arm-generic-fdt,dumpdtb=/tmp/pci.dtb \
	-global xlnx,zynqmp-boot.cpu-num=0 \
	-global xlnx,zynqmp-boot.use-pmufw=true \
	-serial mon:stdio -display none \
	-m ${QEMU_MEM_SZ} \
	-device loader,file=${ZYNQ_DEPLOY_DIR}/u-boot.elf \
	-device loader,file=${ZYNQ_DEPLOY_DIR}/arm-trusted-firmware.elf,cpu-num=0 \
	-device loader,file=${ZYNQ_DEPLOY_DIR}/system.dtb,addr=0x1407f000 \
	-net nic,model=cadence_gem -net nic,model=cadence_gem \
	-net nic,model=cadence_gem -net nic,model=cadence_gem,netdev=net3 \
	-netdev user,id=net3,net=10.0.2.0/24,tftp=${ZYNQ_DEPLOY_DIR}/,hostfwd=tcp:127.0.0.1:50491-10.0.2.15:22 \
	-hw-dtb ${ZYNQ_DTB_DIR_MARCH}/zcu102-arm.dtb \
	-machine-path ${QEMU_MACH_PATH} \
	-drive file=${QEMU_DOM0_ROOTFS},format=raw,id=sata-drive-dom0 \
	-drive file=${QEMU_DOMU_ROOTFS},format=raw,id=sata-drive-domu \
	-device ide-hd,drive=sata-drive-dom0,bus=ahci@0xFD0C0000.0 \
	-device ide-hd,drive=sata-drive-domu,bus=ahci@0xFD0C0000.1 \
	-device igb \
#	-device xlnx-pcie-rp,bus=pcie.0,id=pcie.1,port=1,chassis=1 \
#	-device pci-bridge,addr=00.0,bus=pcie.1,id=pcie.2,chassis_nr=2 \
#	-device igb,bus=pcie.2,addr=01.0 \
#	-s \

