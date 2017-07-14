LICENSE = "CLOSED"

IMAGES_DIR="boot/domu"
FILES_${PN} += "${base_prefix}/${IMAGES_DIR}"

# FIXME: if not forced and sstate cache is used then an old version of
# this package (read old DomU kernel images) can be used from cache
# regardless of the fact that binaries may have actually changed, e.g.
# the recipe code is not changed, there is no SRC_URI with checksum
# force install so if DomU kernel changes we use the latest binaries
do_install[nostamp] = "1"
do_install() {
   install -d "${D}/${base_prefix}/${IMAGES_DIR}"
   find "${XT_SHARED_ROOTFS_DIR}/${IMAGES_DIR}" -iname 'Image*' -exec \
   cp -f --no-dereference --preserve=links {} "${D}/${base_prefix}/${IMAGES_DIR}" \;
}
