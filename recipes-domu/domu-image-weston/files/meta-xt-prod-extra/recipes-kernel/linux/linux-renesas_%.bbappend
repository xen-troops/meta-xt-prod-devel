FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git;protocol=https"

BRANCH = "v5.10/rcar-5.0.0.rc4-xt0.1"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "5.10.0"

KBUILD_DEFCONFIG_rcar = ""
SRC_URI_append = " \
    file://defconfig \
	file://0001-Revert-tee-optee-replace-use-of-ioremap_nocache-with.patch \
	file://0002-Revert-tee-optee-add-SMC-of-START_DLOG_OUTPUT-to-rca.patch \
	file://0003-Revert-tee-optee-Modify-duration-of-spinlock-for-lis.patch \
	file://0004-Revert-tee-optee-Change-wait-to-interruptible.patch \
	file://0005-Revert-tee-optee-Change-workqueue-to-kthread-in-debu.patch \
	file://0006-Revert-tee-Add-a-macro-to-provide-a-register-functio.patch \
	file://0007-Revert-tee-optee-add-r-car-original-function.patch \
"

KERNEL_FEATURES_remove = "cfg/virtio.scc"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMU}"

do_deploy_append() {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

