IMAGE_INSTALL_append = " \
    parted \
    dpkg \
    rpm \
    opkg \
    wget \
    vim \
    e2fsprogs \
    dosfstools \
    bash \
    rsync \
"

IMAGE_ROOTFS_SIZE = "65535"

DEPENDS += "u-boot-mkimage-native parted-native"

addtask generate_uboot_image after do_image_cpio before do_image_wic

do_generate_uboot_image() {
    ${STAGING_BINDIR_NATIVE}/uboot-mkimage -A arm64 -O linux -T ramdisk -C gzip -n "uInitramfs" \
        -d ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.cpio.gz ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio.gz.uInitramfs
    ln -sfr  ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.cpio.gz.uInitramfs ${DEPLOY_DIR_IMAGE}/uInitramfs
}

###############################################################################
# SD card image creation
###############################################################################

WKS_SEARCH_PATH := "${THISDIR}:${WKS_SEARCH_PATH}"

IMAGE_FSTYPES_append = " wic"

WKS_FILE = "core-image-rescue-initramfs.wks"

IMAGE_BOOT_FILES = "\
    Image;boot/Image \
    uInitramfs;boot/uInitramfs \
    dom0.dtb;boot/dom0.dtb \
    xenpolicy;boot/xenpolicy \
    xen-uImage;boot/xen-uImage \
"

addtask copy_xen_images after do_image_cpio before do_image_wic

do_copy_xen_images() {
    # find Xen components which are part of DomD build in its deploy dir
    domd_name=`ls ${DEPLOY_DIR}/.. | grep domd`
    domd_root="${DEPLOY_DIR}/../${domd_name}"

    xenpolicy=`find $domd_root -name xenpolicy`
    xenuImage=`find $domd_root -name xen-uImage`

    cp -fL "${xenpolicy}" ${DEPLOY_DIR_IMAGE}
    cp -fL "${xenuImage}" ${DEPLOY_DIR_IMAGE}
}

