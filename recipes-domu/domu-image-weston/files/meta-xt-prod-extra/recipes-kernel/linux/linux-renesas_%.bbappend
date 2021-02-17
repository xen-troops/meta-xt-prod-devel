FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/otyshchenko1/linux.git"

BRANCH = "v5.4.72/rcar-4.1.0.rc2-xt0.1"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "5.4.72"
SRC_URI_append = " \
    file://defconfig \
"

KERNEL_FEATURES_remove = "cfg/virtio.scc"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMU}"

do_deploy_append() {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

