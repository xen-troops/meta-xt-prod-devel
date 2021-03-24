################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require inc/xen-version.inc

################################################################################
# Generic
################################################################################

do_configure_append() {
    oe_runmake xt_defconfig
}

do_deploy_append_rcar () {
    if [ -f ${D}/boot/xen ]; then
        uboot-mkimage -A arm64 -C none -T kernel -a 0x78080000 -e 0x78080000 -n "XEN" -d ${D}/boot/xen ${DEPLOYDIR}/xen-${MACHINE}.uImage
        ln -sfr ${DEPLOYDIR}/xen-${MACHINE}.uImage ${DEPLOYDIR}/xen-uImage
    fi

    # assuming xen-syms always present
    tar -cJvf ${DEPLOYDIR}/xen-syms.tar.xz ${S}/xen/xen-syms || true
}
