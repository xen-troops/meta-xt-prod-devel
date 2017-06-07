IMAGE_INSTALL_append = " \
    guest-addons \
    dom0-image-weston-domu-copy-kernel \
    domu-dtb \
    libxenbe \
    displbe \
"

PREFERRED_VERSION_xen = "4.9.0+git%"

populate_append() {
        install -m 0644 ${DEPLOY_DIR_IMAGE}/xen-${MACHINE}.gz ${DEST}/xen.gz
}

# u-boot
PREFERRED_VERSION_u-boot_rcar = "v2015.04%"

# libdrm
PREFERRED_VERSION_libdrm = "2.4.68"
