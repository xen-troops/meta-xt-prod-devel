require inc/xt_shared_env.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

GUEST_DOMA = "${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'doma', '', d)}"

UBOOT_CONFIG[doma] = "xenguest_arm64_android_defconfig"
UBOOT_CONFIG_prepend = "${GUEST_DOMA} "

SRCREV = "${AUTOREV}"
SRC_URI = "\
    git://github.com/xen-troops/u-boot.git;protocol=https;branch=android-master; \
"

FILES_${PN} += " \
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', '${XT_DIR_ABS_ROOTFS_DOMA}', '', d)} \
"
do_install_append() {
    for dom in ${XT_GUESTS_INSTALL}; do
        if [ "${dom}" = "doma" ]; then
           install -d ${D}/${XT_DIR_ABS_ROOTFS_DOMA}
           install -m 0744 ${D}/boot/u-boot-${GUEST_DOMA}-${PV}-${PR}.${UBOOT_SUFFIX}  ${D}/${XT_DIR_ABS_ROOTFS_DOMA}/${UBOOT_BINARY}
           rm -f ${D}/boot/u-boot-${GUEST_DOMA}-${PV}-${PR}.${UBOOT_SUFFIX}
        fi
    done
}
