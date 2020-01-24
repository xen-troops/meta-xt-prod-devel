FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "v4.14.75-ltsi/rcar-3.9.6-xt0.1"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "4.14.75"
SRC_URI_append = " \
    file://defconfig \
"

SRC_URI_append_rcar = " \
    file://salvator-generic-doma.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://salvator-generic-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://xen-chosen.dtsi;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_append_rcar = " \
    renesas/salvator-generic-doma.dtb \
    renesas/salvator-generic-domu.dtb \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMD}"

##############################################################################
# Salvator-X H3 ES3.0 4x2G
###############################################################################
SRC_URI_append_salvator-x-h3-4x2g-xt = " \
    file://r8a7795-salvator-x-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-4x2g-xt = " \
    renesas/r8a7795-salvator-x-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-x-4x2g-domd.dtb \
"

##############################################################################
# Salvator-X H3 ES2.0
###############################################################################
# N.B. Device trees for ES 2.0 are based on and use device trees
# for Salvator-X H3 ES3.0 4x2G: Dom0 has memory and GSX adjustments
# and DomD and DomA and DomU are used as is.
###############################################################################
SRC_URI_append_salvator-x-h3-xt = " \
    file://r8a7795-salvator-x-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-xt = " \
    renesas/r8a7795-salvator-x-dom0.dtb \
    renesas/r8a7795-salvator-x-4x2g-domd.dtb \
"

##############################################################################
# Salvator-XS H3 ES3.0 4x2GB
###############################################################################
SRC_URI_append_salvator-xs-h3-4x2g-xt = " \
    file://r8a7795-salvator-xs-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-xs-h3-4x2g-xt = " \
    renesas/r8a7795-salvator-xs-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-xs-4x2g-domd.dtb \
"

##############################################################################
# Salvator-XS H3 ES2.0
###############################################################################
# N.B. Device trees for ES 2.0 are based on and use device trees
# for Salvator-XS H3 ES3.0 4x2G: Dom0 has memory and GSX adjustments
# and DomD and DomU are used as is.
###############################################################################
SRC_URI_append_salvator-xs-h3-xt = " \
    file://r8a7795-salvator-xs-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-xs-h3-xt = " \
    renesas/r8a7795-salvator-xs-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-xs-4x2g-domd.dtb \
    renesas/r8a7795-salvator-xs-dom0.dtb \
"

##############################################################################
# Salvator-X M3
###############################################################################
# N.B. DomA device tree is reused from Salvator-X H3 ES3.0 4x2G
###############################################################################
SRC_URI_append_salvator-x-m3-xt = " \
    file://r8a7796-salvator-x-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7796-salvator-x-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-m3-xt = " \
    renesas/r8a7796-salvator-x-dom0.dtb \
    renesas/r8a7796-salvator-x-domd.dtb \
"

##############################################################################
# M3ULCB
###############################################################################
SRC_URI_append_m3ulcb-xt = " \
    file://r8a7796-m3ulcb-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7796-m3ulcb-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_m3ulcb-xt = " \
    renesas/r8a7796-m3ulcb-dom0.dtb \
    renesas/r8a7796-m3ulcb-domd.dtb \
"

##############################################################################
# H3ULCB
###############################################################################
SRC_URI_append_h3ulcb-xt = " \
    file://r8a7795-h3ulcb-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-h3ulcb-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_h3ulcb-xt = " \
    renesas/r8a7795-h3ulcb-dom0.dtb \
    renesas/r8a7795-h3ulcb-domd.dtb \
"

##############################################################################
# Salvator-XS M3N
###############################################################################
SRC_URI_append_salvator-xs-m3n-xt = " \
    file://r8a77965-salvator-xs-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a77965-salvator-xs-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-xs-m3n-xt = " \
    renesas/r8a77965-salvator-xs-dom0.dtb \
    renesas/r8a77965-salvator-xs-domd.dtb \
"

##############################################################################
# H3ULCB ES3.0 4x2G
###############################################################################
SRC_URI_append_h3ulcb-4x2g-xt = " \
    file://r8a7795-h3ulcb-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-h3ulcb-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_h3ulcb-4x2g-xt = " \
    renesas/r8a7795-h3ulcb-4x2g-dom0.dtb \
    renesas/r8a7795-h3ulcb-4x2g-domd.dtb \
"

##############################################################################
# H3ULCB ES3.0 4x2G KF
###############################################################################
# FIXME: ulcb.cfg comes from CogentEmbedded's meta-rcar layer, but is only used
# for {h|m}3ulcb machines while we are building for XT machine
# (h3ulcb-4x2g-kf-xt)
###############################################################################
SRC_URI_append_h3ulcb-4x2g-kf-xt = " \
    file://r8a7795-h3ulcb-4x2g-kf-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-h3ulcb-4x2g-kf-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://0001-r8a7795-6-65-.dtsi-Add-multichannel-audio-ranges-tha.patch \
    file://ulcb.cfg \
    file://0001-Update-gntdev-drm_front-DMA-tweaks.patch \
"

KERNEL_DEVICETREE_h3ulcb-4x2g-kf-xt = " \
    renesas/r8a7795-h3ulcb-4x2g-kf-dom0.dtb \
    renesas/r8a7795-h3ulcb-4x2g-kf-domd.dtb \
"

do_deploy_append() {
    for DTB in ${KERNEL_DEVICETREE}
        do
              DTB_BASE_NAME=`basename ${DTB} | awk -F "." '{print $1}'`
              DTB_NAME=`echo ${KERNEL_IMAGE_LINK_NAME} | sed "s/${MACHINE}/${DTB_BASE_NAME}/g"`
              DTB_SYMLINK_NAME=`echo ${DTB_NAME##*-}`
              ln -sfr ${DEPLOYDIR}/${DTB_NAME}.dtb ${DEPLOYDIR}/${DTB_SYMLINK_NAME}.dtb
        done

    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

