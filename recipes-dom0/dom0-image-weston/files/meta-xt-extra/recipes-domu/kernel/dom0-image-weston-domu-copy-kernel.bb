LICENSE = "CLOSED"

IMAGES_DIR="boot/domu"
FILES_${PN} += "${base_prefix}/${IMAGES_DIR}"

do_install() {
   install -d "${D}/${base_prefix}/${IMAGES_DIR}"
   cp -rf "${XT_SHARED_ROOTFS_DIR}/${IMAGES_DIR}" "${D}/${base_prefix}/boot"
}
