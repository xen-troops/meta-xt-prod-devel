FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require xen-version.inc

################################################################################
# Renesas R-Car
################################################################################
# Use Legacy IPMMU-VMSA driver for H3 ES2.0 and M3 based machines
# (for H3 ES3.0 and M3N based machines new IPMMU-VMSA driver is used).
SRC_URI_append_r8a7795-es2 = " \
    file://0001-xt_defconfig-Enable-legacy-IPMMU-VMSA-support.patch \
"

SRC_URI_append_r8a7796 = " \
    file://0001-xt_defconfig-Enable-legacy-IPMMU-VMSA-support.patch \
"

################################################################################
# Generic
################################################################################

FLASK_POLICY_FILE = "xenpolicy-${XEN_REL}*"
FILES_${PN}-flask = " \
    /boot/${FLASK_POLICY_FILE} \
"

do_configure_append() {
    oe_runmake xt_defconfig
}

do_deploy_append_rcar () {
    if [ -f ${D}/boot/xen ]; then
        uboot-mkimage -A arm64 -C none -T kernel -a 0x78080000 -e 0x78080000 -n "XEN" -d ${D}/boot/xen ${DEPLOYDIR}/xen-${MACHINE}.uImage
        ln -sfr ${DEPLOYDIR}/xen-${MACHINE}.uImage ${DEPLOYDIR}/xen-uImage
    fi

    if [ -f ${D}/boot/${FLASK_POLICY_FILE} ]; then
        ln -sfr ${DEPLOYDIR}/${FLASK_POLICY_FILE} ${DEPLOYDIR}/xenpolicy
    fi

    # assuming xen-syms always present
    tar -cJvf ${DEPLOYDIR}/xen-syms.tar.xz ${S}/xen/xen-syms || true
}
