FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "v4.14.75-ltsi/rcar-3.9.6-xt0.1"
SRCREV = "a49b495859d0d379ac4ca2068a5c42c1452df8b3"
LINUX_VERSION = "4.14.75"
SRC_URI_append = " \
    file://defconfig \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMU}"

do_deploy_append() {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

