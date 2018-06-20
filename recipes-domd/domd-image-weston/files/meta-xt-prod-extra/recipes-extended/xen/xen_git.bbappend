FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Renesas R-Car
################################################################################

XEN_REL_rcar = "4.10"
PV = "${XEN_REL}.0+git${SRCPV}"
SRCREV_rcar = "${AUTOREV}"

SRC_URI_rcar = "git://github.com/xen-troops/xen.git;protocol=https;branch=master"

# N.B. as Xen doesn't support partial .cfg as kernel does
# we need to patch it to select disable IPMMU PGT sharing for
# H3 v2.0 and M3 machines
SRC_URI_append_r8a7795-es2 = " \
    file://0001-ipmmu-vmsa-Disable-CONFIG_RCAR_IPMMU_PGT_IS_SHARED.patch \
"

SRC_URI_append_r8a7796 = " \
    file://0001-ipmmu-vmsa-Disable-CONFIG_RCAR_IPMMU_PGT_IS_SHARED.patch \
"

################################################################################
# Generic
################################################################################

FLASK_POLICY_FILE = "xenpolicy-${XEN_REL}.0"
FILES_${PN}-flask = " \
    /boot/${FLASK_POLICY_FILE} \
"

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
