require inc/xt_shared_env.inc

IMAGE_INSTALL_append = " \
    pulseaudio \
    alsa-utils \
    kernel-modules \
    kmscube \
"

IMAGE_INSTALL_remove = " \
    optee-linuxdriver \
    optee-linuxdriver-armtz \
    optee-client \
    libx11-locale \
"

# Use only provided proprietary graphic modules
IMAGE_INSTALL_remove = " \
    packagegroup-graphics-renesas-proprietary \
"

IMAGE_FSTYPES += " ext4"

CORE_IMAGE_BASE_INSTALL_remove += "gtk+3-demo clutter-1.0-examples"

populate_vmlinux () {
    find ${STAGING_KERNEL_BUILDDIR} -iname "vmlinux*" -exec mv {} ${DEPLOY_DIR_IMAGE} \; || true
}

addtask populate_artifacts after do_image_complete before do_build
do_populate_artifacts() {
    ln -sfr ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.ext4 ${XT_DIR_ABS_SHARED_BOOT_DOMU}
}


IMAGE_POSTPROCESS_COMMAND += "populate_vmlinux; "
