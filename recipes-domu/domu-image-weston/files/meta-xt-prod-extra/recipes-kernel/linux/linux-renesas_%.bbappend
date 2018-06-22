FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "master"
SRCREV = "${AUTOREV}"
SRC_URI_append = " \
    file://defconfig \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMU}"

do_deploy_append() {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

