FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

require inc/xt_shared_env.inc

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "yocto-3.7-migration"
SRCREV = "${AUTOREV}"
SRC_URI_append = " \
    file://defconfig \
"

SRC_URI_append_rcar = " \
    file://0001-firmware-Add-xHCI-Host-Controller-firmware.patch \
"

DEPLOYDIR="${XT_DIR_ABS_SHARED_BOOT_DOMD}"

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

