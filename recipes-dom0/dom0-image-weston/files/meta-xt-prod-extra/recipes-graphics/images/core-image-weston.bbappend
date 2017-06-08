IMAGE_INSTALL_append = " \
    guest-addons \
    dom0-image-weston-domu-copy-kernel \
    domu-dtb \
    libxenbe \
    displbe \
"

populate_append() {
        install -m 0644 ${DEPLOY_DIR_IMAGE}/xen-${MACHINE}.gz ${DEST}/xen.gz
}
