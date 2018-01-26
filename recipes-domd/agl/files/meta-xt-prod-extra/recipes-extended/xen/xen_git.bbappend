FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Renesas R-Car
################################################################################
XEN_REL_rcar = "4.9"

SRCREV_rcar = "${AUTOREV}"

SRC_URI_rcar = "git://github.com/xen-troops/xen.git;protocol=https;branch=vgpu-dev"

################################################################################
# Generic
################################################################################

# N.B. as Xen doesn't support partial .cfg as kernel does
# we need to patch it to select GSX IMG as default
SRC_URI_append = " \
    file://0001-Make-GSX-IMG-coproc-default.patch \
"

FLASK_POLICY_FILE = "xenpolicy-${XEN_REL}-rc"

do_deploy_append_rcar () {
    if [ -f ${D}/boot/xen ]; then
        uboot-mkimage -A arm64 -C none -T kernel -a 0x78080000 -e 0x78080000 -n "XEN" -d ${D}/boot/xen ${DEPLOYDIR}/xen-${MACHINE}.uImage
        ln -sfr ${DEPLOYDIR}/xen-${MACHINE}.uImage ${DEPLOYDIR}/xen-uImage
    fi

    if [ -f ${D}/boot/${FLASK_POLICY_FILE} ]; then
        ln -sfr ${DEPLOYDIR}/${FLASK_POLICY_FILE} ${DEPLOYDIR}/xenpolicy
    fi

    # assuming xen-syms always present
    tar -cJvf ${DEPLOYDIR}/xen-syms.tar.xz ${S}/xen/xen-syms
}
