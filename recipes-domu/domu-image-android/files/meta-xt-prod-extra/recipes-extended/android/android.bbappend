SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    repo://github.com/xen-troops/android_manifest;protocol=https;branch=android-10.0.0_r3-master;manifest=doma.xml;scmdata=keep "

# put it out of the source tree, so it can be reused after cleanup
ANDROID_OUT_DIR_COMMON_BASE = "${SSTATE_DIR}/../${ANDROID_PRODUCT}-${SOC_FAMILY}"
ANDROID_PRODUCT_OUT = "${ANDROID_OUT_DIR_COMMON_BASE}/target/product/${ANDROID_PRODUCT}"
ANDROID_HOST_PYTHON="$(dirname ${PYTHON})"

EXTRA_OEMAKE_append = " \
    TARGET_BOARD_PLATFORM=${SOC_FAMILY} \
    TARGET_SOC_REVISION=${SOC_REVISION} \
    OUT_DIR=${ANDROID_OUT_DIR_COMMON_BASE} \
    PRODUCT_OUT=${ANDROID_PRODUCT_OUT} \
    HOST_PYTHON=${ANDROID_HOST_PYTHON} \
"

ANDROID_KERNEL_NAME ?= "kernel"
ANDROID_UNPACKED_KERNEL_NAME ?= "vmlinux"
PATCHTOOL = "git"
DEPENDS += " python-clang-native"
DEPENDS += "python-pycrypto-native"

################################################################################
# Renesas R-Car
################################################################################

SOC_FAMILY_r8a7795 = "r8a7795"
SOC_FAMILY_r8a7796 = "r8a7796"
SOC_FAMILY_r8a77965 = "r8a77965"

SOC_REVISION = ""
SOC_REVISION_r8a7795-es2 = "es2"

ANDROID_VARIANT_rcar = "userdebug"
ANDROID_PRODUCT_rcar = "xenvm"

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
    install -d "${XT_DIR_ABS_SHARED_BOOT_DOMA}"

    if [ -z ${TARGET_PREBUILT_KERNEL} ];then
        local FILE_TYPE=$(file ${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME} -b | awk '{ print $1 }')
        if [ ${FILE_TYPE} == "LZ4" ];then
            # uncompress lz4 packed kernel
            lz4 -d "${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME}" "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}"
        else
            ln -sfr "${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME}" "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}"
        fi
        # copy kernel to shared folder, so Dom0 can pick it up
        install -m 0744 "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}"

        # copy kernel to the deploy directory
        install -m 0744 "${ANDROID_PRODUCT_OUT}/${ANDROID_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}"
        install -m 0744 "${ANDROID_PRODUCT_OUT}/${ANDROID_UNPACKED_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}"
        find ${ANDROID_PRODUCT_OUT}obj/KERNEL_OBJ -iname "vmlinux" -exec tar -cJvf ${DEPLOY_DIR_IMAGE}/vmlinux.tar.xz {} \; || true
    else
        # copy uncompressed kernel to shared folder, so Dom0 can pick it up
        install -m 0744 "${TARGET_PREBUILT_KERNEL}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}"
        # copy kernel to the deploy directory
        install -m 0744 "${TARGET_PREBUILT_KERNEL}" "${DEPLOY_DIR_IMAGE}"
    fi

    # copy images to the deploy directory
    find "${ANDROID_PRODUCT_OUT}/" -maxdepth 1 -iname '*.img' -exec \
        cp -f --no-dereference --preserve=links {} "${DEPLOY_DIR_IMAGE}" \;
    ln -sfr "${DEPLOY_DIR_IMAGE}/${ANDROID_UNPACKED_KERNEL_NAME}" "${DEPLOY_DIR_IMAGE}/Image"
    ln -sfr "${XT_DIR_ABS_SHARED_BOOT_DOMA}/${ANDROID_UNPACKED_KERNEL_NAME}" "${XT_DIR_ABS_SHARED_BOOT_DOMA}/Image"
}

