SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    repo://github.com/xen-troops/android_manifest;protocol=https;branch=android-11-master;manifest=doma.xml;scmdata=keep "

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

    # copy images to the deploy directory
    find "${ANDROID_PRODUCT_OUT}/" -maxdepth 1 -iname '*.img' -exec \
        cp -f --no-dereference --preserve=links {} "${DEPLOY_DIR_IMAGE}" \;
}

