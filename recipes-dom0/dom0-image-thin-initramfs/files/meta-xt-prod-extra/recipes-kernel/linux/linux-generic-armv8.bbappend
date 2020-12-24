FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "v4.14.75-ltsi/rcar-3.9.6-xt0.1"
SRCREV = "a49b495859d0d379ac4ca2068a5c42c1452df8b3"
LINUX_VERSION = "4.14.75"

SRC_URI = " \
    git://github.com/xen-troops/linux.git;branch=${BRANCH} \
    file://defconfig \
"

BRANCH_qemu-xen = "xilinx-pcie-no-fw"
SRCREV_qemu-xen = "${AUTOREV}"
LINUX_VERSION_qemu-xen = "5.10-rc7"

LIC_FILES_CHKSUM_qemu-xen = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI_qemu-xen = " \
    git://github.com/xen-troops/linux.git;branch=${BRANCH} \
    file://qemu-xen/defconfig;destsuffix=defconfig \
"

KERNEL_DEVICETREE_qemu-xen = " \
    xilinx/zynqmp-zcu102-rev1.0.dtb \
"

FILES_${KERNEL_PACKAGE_NAME}-base += " \
    ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo \
"

do_deploy_append () {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}
