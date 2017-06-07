FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "vgpu-dev"
SRCREV = "${AUTOREV}"
SRC_URI_append = " \
    file://defconfig \
"

###############################################################################
# H3ULCB
###############################################################################
KERNEL_DEVICETREE_h3ulcb-xt = "renesas/r8a7795-h3ulcb-dom0.dtb"

###############################################################################
# M3ULCB
###############################################################################
SRC_URI_append_m3ulcb-xt = "file://r8a7796-m3ulcb-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas"
KERNEL_DEVICETREE_m3ulcb-xt = "renesas/r8a7796-m3ulcb-dom0.dtb"

###############################################################################
# Salvator-X M3
###############################################################################
KERNEL_DEVICETREE_salvator-x-m3-xt = "renesas/r8a7796-salvator-x-dom0.dtb"

###############################################################################
# Salvator-X H3
###############################################################################
SRC_URI_append_salvator-x-h3-xt = " \
    file://r8a7795-salvator-x-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-xt = " \
    renesas/r8a7795-salvator-x-dom0.dtb \
    renesas/r8a7795-salvator-x-domu.dtb \
"

do_install_append_salvator-x-h3-xt() {
    install -d ${D}${base_prefix}/xen
    install -m 0644 ${B}/arch/${ARCH}/boot/dts/renesas/r8a7795-salvator-x-domu.dtb ${D}${base_prefix}/xen/domu.dtb
}

PACKAGES += "domu-dtb"
FILES_domu-dtb = "${base_prefix}/xen/*"
