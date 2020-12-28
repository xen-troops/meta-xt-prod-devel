FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "v4.14.75-ltsi/rcar-3.9.6-xt0.1"
SRCREV = "a49b495859d0d379ac4ca2068a5c42c1452df8b3"
LINUX_VERSION = "4.14.75"
SRC_URI_append = " \
    file://defconfig \
    file://r8169.cfg \
    file://8139cp.cfg \
    file://0001-r8169-Implement-IRQ-via-timer-polling.patch \
"

# Do not autoload r8169 and 8139cp drivers
KERNEL_MODULE_PROBECONF += "r8169"
module_conf_r8169 = "blacklist r8169"

KERNEL_MODULE_PROBECONF += "8139cp"
module_conf_8139cp = "blacklist 8139cp"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMU}"

do_deploy_append() {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

