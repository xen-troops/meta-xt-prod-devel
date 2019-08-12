FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "master"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "4.14.75"
SRC_URI_append = " \
    file://defconfig \
"

SRC_URI_append_rcar = " \
    file://salvator-generic-doma.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://xen-chosen.dtsi;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_append_rcar = " \
    renesas/salvator-generic-doma.dtb \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMD}"

##############################################################################
# Salvator-X H3 ES3.0 4x2G
###############################################################################
SRC_URI_append_salvator-x-h3-4x2g-xt = " \
    file://r8a7795-salvator-x-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-4x2g-xt = " \
    renesas/r8a7795-salvator-x-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-x-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-domu.dtb \
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
    file://r8a7795-salvator-x-4x2g-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-xt = " \
    renesas/r8a7795-salvator-x-dom0.dtb \
    renesas/r8a7795-salvator-x-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-domu.dtb \
"

##############################################################################
# Salvator-XS H3 ES3.0 4x2GB
###############################################################################
SRC_URI_append_salvator-xs-h3-4x2g-xt = " \
    file://r8a7795-salvator-xs-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-xs-h3-4x2g-xt = " \
    renesas/r8a7795-salvator-xs-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-xs-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-domu.dtb \
"

##############################################################################
# Salvator-XS H3 ES3.0 2x2GB
###############################################################################
# N.B. Device trees for ES 3.0 2x2G are based on and use device trees
# for Salvator-XS H3 ES3.0 4x2G: Dom0 has memory and GSX adjustments
# and DomD and DomU are used as is.
###############################################################################
SRC_URI_append_salvator-xs-h3-2x2g-xt = " \
    file://r8a7795-salvator-xs-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-2x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-xs-h3-2x2g-xt = " \
    renesas/r8a7795-salvator-xs-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-xs-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-domu.dtb \
    renesas/r8a7795-salvator-xs-2x2g-dom0.dtb \
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
    file://r8a7795-salvator-x-4x2g-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-xs-h3-xt = " \
    renesas/r8a7795-salvator-xs-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-xs-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-domu.dtb \
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
    file://r8a7796-salvator-x-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-m3-xt = " \
    renesas/r8a7796-salvator-x-dom0.dtb \
    renesas/r8a7796-salvator-x-domd.dtb \
    renesas/r8a7796-salvator-x-domu.dtb \
"

##############################################################################
# H3ULCB ES3.0 4x2G
###############################################################################
# N.B. DomU device tree is reused from Salvator-X H3 ES3.0 4x2G
###############################################################################
SRC_URI_append_h3ulcb-4x2g-xt = " \
    file://r8a7795-h3ulcb-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-h3ulcb-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_h3ulcb-4x2g-xt = " \
    renesas/r8a7795-h3ulcb-4x2g-dom0.dtb \
    renesas/r8a7795-h3ulcb-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-domu.dtb \
"

##############################################################################
# H3ULCB ES3.0 4x2G KF
###############################################################################
# N.B. DomU device tree is reused from Salvator-X H3 ES3.0 4x2G
# FIXME: ulcb.cfg comes from CogentEmbedded's meta-rcar layer, but is only used
# for {h|m}3ulcb machines while we are building for XT machine
# (h3ulcb-4x2g-kf-xt)
###############################################################################
SRC_URI_append_h3ulcb-4x2g-kf-xt = " \
    file://r8a7795-h3ulcb-4x2g-kf-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-h3ulcb-4x2g-kf-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domu.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://0001-r8a7795-6-65-.dtsi-Add-multichannel-audio-ranges-tha.patch \
    file://ulcb.cfg \
"

KERNEL_DEVICETREE_h3ulcb-4x2g-kf-xt = " \
    renesas/r8a7795-h3ulcb-4x2g-kf-dom0.dtb \
    renesas/r8a7795-h3ulcb-4x2g-kf-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-domu.dtb \
"

SRC_URI_remove_kingfisher = " \
    file://0112-ARM64-dts-renesas-ulcb-Make-AK4613-sound-device-name.patch \
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

