DEPENDS += "u-boot-mkimage-native"

inherit deploy

#Add Xen and additional packages to build
IMAGE_INSTALL_append = " \
    xen-xencommons \
    xen-xenstat \
    xen-misc \
    xen-xenhypfs \
    dom0 \
    dom0-run-vcpu_pin \
    dom0-run-set_root_dev \
    domd \
    domd-run \
    domd-install-artifacts \
"

XT_GUESTS_INSTALL ?= "doma domf"

python __anonymous () {
    guests = d.getVar("XT_GUESTS_INSTALL", True).split()
    if "doma" in guests :
        d.appendVar("IMAGE_INSTALL", " doma doma-run doma-install-artifacts")
    if "domf" in guests :
        d.appendVar("IMAGE_INSTALL", " domf domf-run domf-install-artifacts")
    if "domr" in guests :
        d.appendVar("IMAGE_INSTALL", " domr domr-run domr-install-artifacts")
    if "domu" in guests :
        d.appendVar("IMAGE_INSTALL", " domu domu-run domu-install-artifacts")
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

