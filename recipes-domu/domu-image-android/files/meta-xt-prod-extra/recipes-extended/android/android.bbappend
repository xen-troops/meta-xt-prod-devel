SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=prod_ces2018/doma.xml;scmdata=keep \
    file://0001-HACK-If-partition-name-wasn-t-present-use-device-nam.patch;patchdir=system/core \
"
# put it out of the source tree, so it can be reused after cleanup
ANDROID_OUT_DIR_COMMON_BASE = "${SSTATE_DIR}/../${PN}-${ANDROID_PRODUCT}-${ANDROID_VARIANT}-${SOC_FAMILY}-out"

EXTRA_OEMAKE_append = " \
    TARGET_BOARD_PLATFORM=${SOC_FAMILY} \
    OUT_DIR_COMMON_BASE=${ANDROID_OUT_DIR_COMMON_BASE} \
"

# Android adds the source directoy name to the out directory name, e.g. repo in our case,
# where "repo" is hardcoded in bitbake's repo fetcher
ANDROID_ARTIFACTS_DIR = "${ANDROID_OUT_DIR_COMMON_BASE}/repo/target/product/${ANDROID_PRODUCT}/"
ANDROID_KERNEL_NAME ?= "kernel"
ANDROID_UNPACKED_KERNEL_NAME ?= "vmlinux"

################################################################################
# Renesas R-Car
################################################################################

SOC_FAMILY_r8a7795 = "r8a7795"
SOC_FAMILY_r8a7796 = "r8a7796"

ANDROID_VARIANT_rcar = "userdebug"
ANDROID_PRODUCT_salvator = "salvator"

################################################################################
# Deploy images
################################################################################
# FIXME: if not forced and sstate cache is used then an old version of
# this package (read old DomA images) can be used from cache
# regardless of the fact that binaries may have actually changed, e.g.
# the recipe code is not changed, there is no SRC_URI with checksum
# Force install so if DomA images change we use the latest binaries
do_install[nostamp] = "1"
do_install() {
    install -d "${DEPLOY_DIR_IMAGE}"

    # uncompress lz4 packed kernel
    lz4 -d "${ANDROID_ARTIFACTS_DIR}/${ANDROID_KERNEL_NAME}" "${ANDROID_ARTIFACTS_DIR}/${ANDROID_UNPACKED_KERNEL_NAME}"
    # copy uncompressed kernel to shared folder, so Dom0 can pick it up
    install -d "${XT_DIR_ABS_SHARED_BOOT_DOMA}"
    install -m 0744 "${ANDROID_ARTIFACTS_DIR}/${ANDROID_UNPACKED_KERNEL_NAME}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}"
    ln -sfr "${XT_DIR_ABS_SHARED_BOOT_DOMA}/${ANDROID_UNPACKED_KERNEL_NAME}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}/Image"

    # copy images to the deploy directory
    find "${ANDROID_ARTIFACTS_DIR}/" -maxdepth 1 -iname '*.img' -exec \
        cp -f --no-dereference --preserve=links {} "${DEPLOY_DIR_IMAGE}" \;
    # and the kernel as well
    install -m 0744 "${ANDROID_ARTIFACTS_DIR}/${ANDROID_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}"
    install -m 0744 "${ANDROID_ARTIFACTS_DIR}/${ANDROID_UNPACKED_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}"
    ln -sfr "${DEPLOY_DIR_IMAGE}/${ANDROID_UNPACKED_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}/Image"
    find ${ANDROID_ARTIFACTS_DIR}obj/KERNEL_OBJ -iname "vmlinux" -exec tar -cJvf ${DEPLOY_DIR_IMAGE}/vmlinux.tar.xz {} \;
}

