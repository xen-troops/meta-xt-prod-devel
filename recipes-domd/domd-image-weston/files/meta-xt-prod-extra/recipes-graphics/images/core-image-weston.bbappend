require inc/xt_shared_env.inc 

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
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'displaymanager', '', d)} \
"

python __anonymous () {
    if (d.getVar("AOS_VIS_PACKAGE_DIR", True) or "") == "" and not "domu" in (d.getVar("XT_GUESTS_INSTALL", True).split()):
        d.appendVar("IMAGE_INSTALL", "aos-vis")
    if (d.getVar("AOS_VIS_PACKAGE_DIR", True) or "") != "" and not "domu" in (d.getVar("XT_GUESTS_INSTALL", True).split()):
        d.appendVar("IMAGE_INSTALL", "ca-certificates")
}

# Configuration for ARM Trusted Firmware
EXTRA_IMAGEDEPENDS += " arm-trusted-firmware"

IMAGE_FSTYPES += " ext4" 

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
    if echo "${XT_GUESTS_INSTALL}" | grep -qi "domu";then
        exit 0
    fi
    if [ ! -z "${AOS_VIS_PACKAGE_DIR}" ];then
        opkg install ${AOS_VIS_PACKAGE_DIR}/aos-vis
    fi
}

addtask populate_artifacts after do_image_complete before do_build
do_populate_artifacts() {
    ln -sfr ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.ext4 ${XT_DIR_ABS_SHARED_BOOT_DOMD}
}

ROOTFS_POSTPROCESS_COMMAND += "install_aos; "
