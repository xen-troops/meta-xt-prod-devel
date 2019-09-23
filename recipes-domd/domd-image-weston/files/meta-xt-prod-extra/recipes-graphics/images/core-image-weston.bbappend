IMAGE_INSTALL_append = " \
    pulseaudio \
    alsa-utils \
    wayland-ivi-extension \
    packagegroup-xt-core-guest-addons \
    packagegroup-xt-core-xen \
    packagegroup-xt-core-pv \
    packagegroup-xt-core-network \
    kernel-modules \
    kmscube \
    optee-os \
    displaymanager \
    guest-addons-display-manager-service \
"

python __anonymous () {
    if (d.getVar("AOS_VIS_PACKAGE_DIR", True) or "") == "":
        d.appendVar("IMAGE_INSTALL", "aos-vis")
}

# Configuration for ARM Trusted Firmware
EXTRA_IMAGEDEPENDS += " arm-trusted-firmware"

# u-boot
DEPENDS += " u-boot"

# Do not support secure environment
IMAGE_INSTALL_remove = " \
    optee-linuxdriver \
    optee-linuxdriver-armtz \
    optee-client \
    libx11-locale \
    dhcp-client \
"

# Use only provided proprietary graphic modules
IMAGE_INSTALL_remove = " \
    packagegroup-graphics-renesas-proprietary \
"

IMAGE_INSTALL_append_kingfisher = " \
    iw \
"

IMAGE_INSTALL_remove_kingfisher = " \
    wireless-tools \
"

CORE_IMAGE_BASE_INSTALL_remove += "gtk+3-demo clutter-1.0-examples"

populate_vmlinux () {
    find ${STAGING_KERNEL_BUILDDIR} -iname "vmlinux*" -exec mv {} ${DEPLOY_DIR_IMAGE} \; || true
}

IMAGE_POSTPROCESS_COMMAND += "populate_vmlinux; "

install_aos () {
    if [ ! -z "${AOS_VIS_PACKAGE_DIR}" ];then
        opkg install ${AOS_VIS_PACKAGE_DIR}/ca-certificates_20170717-r0_all.ipk \
                     ${AOS_VIS_PACKAGE_DIR}/aos-vis_git-r0_aarch64.ipk
    fi
}

ROOTFS_POSTPROCESS_COMMAND += "install_aos; "
