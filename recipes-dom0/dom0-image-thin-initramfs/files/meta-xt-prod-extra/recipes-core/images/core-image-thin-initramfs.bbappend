DEPENDS += "${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'u-boot', '', d)} u-boot-mkimage-native"

inherit deploy

#Add Xen and additional packages to build
IMAGE_INSTALL_append = " \
    xen-xencommons \
    xen-xenstat \
    xen-misc \
    xen-xenhypfs \
    ${@bb.utils.contains('DISTRO_FEATURES', 'qemu_xen', 'xen-base', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'qemu_xen', 'xen-devd', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'qemu_xen', 'pciutils', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'qemu_xen', 'openssh-scp', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'qemu_xen', 'openssh-sshd', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'qemu_xen', 'haveged', '', d)} \
    dom0 \
    dom0-run-vcpu_pin \
    dom0-run-set_root_dev \
    domd \
    domd-run \
    domd-install-artifacts \
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'u-boot', '', d)} \
"

XT_GUESTS_INSTALL ?= "doma domf"

python __anonymous () {
    guests = d.getVar("XT_GUESTS_INSTALL", True).split()
    if "doma" in guests :
        d.appendVar("IMAGE_INSTALL", " doma doma-run")
    if "domf" in guests :
        d.appendVar("IMAGE_INSTALL", " domf domf-run domf-install-artifacts")
    if "domr" in guests :
        d.appendVar("IMAGE_INSTALL", " domr domr-run domr-install-artifacts")
    if "domu" in guests :
        d.appendVar("IMAGE_INSTALL", " domu domu-run domu-install-artifacts")
    rootfs_extra_space = d.getVar("DISTRO_FEATURES", True).split()
    # Check if extra rootfs space, KBytes, required
    if "qemu_xen" in rootfs_extra_space :
        d.setVar("IMAGE_ROOTFS_EXTRA_SPACE", "102400")
}

generate_uboot_image() {
    ${STAGING_BINDIR_NATIVE}/uboot-mkimage -A arm64 -O linux -T ramdisk -C gzip -n "uInitramfs" \
        -d ${DEPLOYDIR}-image-complete/${IMAGE_LINK_NAME}.cpio.gz ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio.gz.uInitramfs
    ln -sfr  ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio.gz.uInitramfs ${DEPLOY_DIR_IMAGE}/uInitramfs
}

populate_vmlinux () {
    find ${STAGING_KERNEL_BUILDDIR} -iname "vmlinux*" -exec mv {} ${DEPLOY_DIR_IMAGE} \; || true
}

IMAGE_POSTPROCESS_COMMAND += " generate_uboot_image; populate_vmlinux; "

IMAGE_ROOTFS_SIZE = "65535"

IMAGE_FSTYPES += "${@bb.utils.contains('DISTRO_FEATURES', 'qemu_xen', 'ext4', '', d)}"
