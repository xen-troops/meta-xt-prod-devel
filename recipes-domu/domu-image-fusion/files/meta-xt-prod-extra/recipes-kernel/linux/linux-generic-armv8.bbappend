require inc/xt_shared_env.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "master"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "4.14.35"

SRC_URI = " \
    git://github.com/xen-troops/linux.git;branch=${BRANCH};protocol=https \
    file://defconfig \
  "

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMF}"

do_deploy_append () {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

