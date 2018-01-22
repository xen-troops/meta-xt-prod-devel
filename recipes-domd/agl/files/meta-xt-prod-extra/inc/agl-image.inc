IMAGE_INSTALL_append = " \
    guest-addons \
    libxenbe \
    displbe \
    displaymanager \
    sndbe \
    guest-addons-displbe-service \
    guest-addons-android-disks-service \
    guest-addons-bridge-up-notification-service \
    guest-addons-bridge-config \
    kmscube \
    cldemo \
    alsa-utils \
    sensors-emulator \
"

#Add Xen and additional packages to build
IMAGE_INSTALL_append = " \
    dnsmasq \
    nftables \
    ntpdate-systemd \
    tzdata \
    dhcp-client \
    xen-base \
    xen-flask \
    xen-xenstat \
"

# Configuration for ARM Trusted Firmware
EXTRA_IMAGEDEPENDS += " arm-trusted-firmware"

# u-boot
DEPENDS += " u-boot"

# Dom0 is a generic ARMv8 machine w/o machine overrides,
# but still needs to know which system we are building,
# e.g. Salvator-X M3 or H3, for instance
# So, we provide machine overrides from this build to Dom0
EXTRA_IMAGEDEPENDS += " domd-install-machine-overrides"

# Do not support secure environment
IMAGE_INSTALL_remove = " \
    optee-linuxdriver \
    optee-linuxdriver-armtz \
    optee-client \
"

CORE_IMAGE_BASE_INSTALL_remove += "gtk+3-demo clutter-1.0-examples"

populate_vmlinux () {
    find ${STAGING_KERNEL_BUILDDIR} -iname "vmlinux*" -exec mv {} ${DEPLOY_DIR_IMAGE} \; || true
}

IMAGE_POSTPROCESS_COMMAND += "populate_vmlinux; "

