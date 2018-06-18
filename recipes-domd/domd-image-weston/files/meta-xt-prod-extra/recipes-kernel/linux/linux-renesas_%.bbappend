FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "master"
SRCREV = "${AUTOREV}"
SRC_URI_append = " \
    file://defconfig \
"

SRC_URI_append_rcar = " \
    file://0008-soc-Extend-always-on-logic-to-H3-ES3.0.patch \
    file://0001-firmware-Add-xHCI-Host-Controller-firmware.patch \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMD}"

##############################################################################
# Salvator-XS H3
###############################################################################
SRC_URI_append_salvator-xs-h3-xt = " \
    file://r8a7795-salvator-xs-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-xs-doma.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-xs-h3-xt = " \
    renesas/r8a7795-salvator-xs-dom0.dtb \
    renesas/r8a7795-salvator-xs-domd.dtb \
    renesas/r8a7795-salvator-xs-doma.dtb \
"

##############################################################################
# Salvator-X H3 ES3.0 4x2G
###############################################################################
SRC_URI_append_salvator-x-h3-4x2g-xt = " \
    file://r8a7795-salvator-x-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-doma.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-4x2g-xt = " \
    renesas/r8a7795-salvator-x-4x2g-dom0.dtb \
    renesas/r8a7795-salvator-x-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-doma.dtb \
"

##############################################################################
# Salvator-X H3 ES2.0
###############################################################################
# N.B. Device trees for ES 2.0 are based on and use device trees
# for Salvator-X H3 ES3.0 4x2G: Dom0 has memory and GSX adjustments
# and DomD and DomA are used as is.
###############################################################################
SRC_URI_append_salvator-x-h3-xt = " \
    file://r8a7795-salvator-x-4x2g-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-domd.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-4x2g-doma.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
    file://r8a7795-salvator-x-dom0.dts;subdir=git/arch/${ARCH}/boot/dts/renesas \
"

KERNEL_DEVICETREE_salvator-x-h3-xt = " \
    renesas/r8a7795-salvator-x-dom0.dtb \
    renesas/r8a7795-salvator-x-4x2g-domd.dtb \
    renesas/r8a7795-salvator-x-4x2g-doma.dtb \
"

do_deploy_append() {
    for DTB in ${KERNEL_DEVICETREE}
        do
              DTB_BASE_NAME=`basename ${DTB} | awk -F "." '{print $1}'`
              DTB_NAME=`echo ${KERNEL_IMAGE_SYMLINK_NAME} | sed "s/${MACHINE}/${DTB_BASE_NAME}/g"`
              DTB_SYMLINK_NAME=`echo ${DTB_NAME##*-}`
              if [ -z "${KERNEL_IMAGETYPES}" ] ; then
                  ln -sfr ${DEPLOYDIR}/${DTB_NAME}.dtb ${DEPLOYDIR}/${DTB_SYMLINK_NAME}.dtb
              else
                  for type in ${KERNEL_IMAGETYPES} ; do
                      ln -sfr ${DEPLOYDIR}/${type}-${DTB_NAME}.dtb ${DEPLOYDIR}/${DTB_SYMLINK_NAME}.dtb
                      # FIXME: we can take any image type to create this symlink, so take the first one
                      break
                  done
              fi
        done

    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}

