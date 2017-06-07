################################################################################
# Renesas R-Car
################################################################################
XEN_REL_rcar = "4.9"

SRCREV_rcar = "${AUTOREV}"

SRC_URI_rcar = "git://github.com/xen-troops/xen.git;protocol=https;branch=vgpu-dev"

FLASK_POLICY_FILE_rcar = "xenpolicy-4.9-rc"

do_deploy_append_rcar () {
    if [ -f ${D}/boot/xen ]; then
        uboot-mkimage -A arm64 -C none -T kernel -a 0x78080000 -e 0x78080000 -n "XEN" -d ${D}/boot/xen ${DEPLOYDIR}/xen-${MACHINE}.uImage
    fi
}
