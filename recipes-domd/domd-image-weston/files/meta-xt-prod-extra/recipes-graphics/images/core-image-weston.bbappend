IMAGE_INSTALL_append = " \
    perf \
    glmark2 \
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
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'displaymanager', '', d)} \
"

python __anonymous () {
    if 'vis' in d.getVar('DISTRO_FEATURES', True):
        if d.getVar("AOS_VIS_PACKAGE_DIR", True):
            # VIS is from prebuilt binaries
            d.appendVar("IMAGE_INSTALL", " ca-certificates")
        else:
            # VIS is from sources
            d.appendVar("IMAGE_INSTALL", " aos-vis")
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

CORE_IMAGE_BASE_INSTALL_remove += "gtk+3-demo clutter-1.0-examples"

populate_vmlinux () {
    find ${STAGING_KERNEL_BUILDDIR} -iname "vmlinux*" -exec mv {} ${DEPLOY_DIR_IMAGE} \; || true
}

IMAGE_POSTPROCESS_COMMAND += "populate_vmlinux; "

install_aos () {
    if [ ! -z "${AOS_VIS_PACKAGE_DIR}" ];then
        opkg install ${AOS_VIS_PACKAGE_DIR}/aos-vis
    fi
}

ROOTFS_POSTPROCESS_COMMAND += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'vis', 'install_aos;', '', d)} \
"
