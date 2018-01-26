FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "ces2018"
SRCREV = "${AUTOREV}"
SRC_URI_append = " \
    file://defconfig \
"

SRC_URI_append_rcar = " \
    file://0001-r8a7795-6-.dtsi-Add-ranges-that-AUDMACs-relies-on.patch \
    file://0002-HACK-Enable-VSPM-related-clocks-in-rcar-du-driver.patch \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMD}"

###############################################################################
# H3ULCB
###############################################################################
KERNEL_DEVICETREE_h3ulcb-xt = "renesas/r8a7795-h3ulcb-domd.dtb"

###############################################################################
# M3ULCB
###############################################################################
SRC_URI_append_m3ulcb-xt = "file://r8a7796-m3ulcb-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas"
KERNEL_DEVICETREE_m3ulcb-xt = "renesas/r8a7796-m3ulcb-domd.dtb"

###############################################################################
# Salvator-X M3
###############################################################################
SRC_URI_append_salvator-x-m3-xt = " \
    file://r8a7796-salvator-x-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7796-salvator-x-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7796-salvator-x-doma.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-m3-xt = " \
    renesas/r8a7796-salvator-x-dom0.dtb \
    renesas/r8a7796-salvator-x-domd.dtb \
    renesas/r8a7796-salvator-x-doma.dtb \
"

###############################################################################
# Salvator-X H3
###############################################################################
SRC_URI_append_salvator-x-h3-xt = " \
    file://r8a7795-salvator-x-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-doma.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-xt = " \
    renesas/r8a7795-salvator-x-dom0.dtb \
    renesas/r8a7795-salvator-x-domd.dtb \
    renesas/r8a7795-salvator-x-doma.dtb \
"

do_deploy_append() {
    for DTB in ${KERNEL_DEVICETREE}
        do
              DTB_BASE_NAME=`basename ${DTB} | awk -F "." '{print $1}'`
              DTB_NAME=`echo ${KERNEL_IMAGE_SYMLINK_NAME} | sed "s/${MACHINE}/${DTB_BASE_NAME}/g"`
              DTB_SYMLINK_NAME=`echo ${DTB_NAME##*-}`
              for type in ${KERNEL_IMAGETYPES} ; do
                  ln -sfr ${DEPLOYDIR}/${type}-${DTB_NAME}.dtb ${DEPLOYDIR}/${DTB_SYMLINK_NAME}.dtb
                  # FIXME: we can take any image type to create this symlink, so take the first one
                  break
              done
        done

    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

