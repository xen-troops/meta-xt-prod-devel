IMAGE_INSTALL_append = " \
    tzdata \
"

populate_vmlinux () {
    find ${STAGING_KERNEL_BUILDDIR} -iname "vmlinux*" -exec mv {} ${DEPLOY_DIR_IMAGE} \;
}

IMAGE_POSTPROCESS_COMMAND += "populate_vmlinux; "
