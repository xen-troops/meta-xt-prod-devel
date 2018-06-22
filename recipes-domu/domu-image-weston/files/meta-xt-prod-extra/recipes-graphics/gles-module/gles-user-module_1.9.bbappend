require inc/xt_shared_env.inc

BRANCH = "1.9/4991288"
SRCREV = "${AUTOREV}"

SRC_URI_remove = " \
    file://gcc6_pvr_um_1.9.patch \
"

EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"
DEPENDS += " gles-module-egl-headers wayland-native"
RDEPENDS_${PN} += "python"

do_install_append() {
    install -d ${DEPLOY_DIR_IMAGE}/xt-rcar
    cp -rf ${D}/* ${DEPLOY_DIR_IMAGE}/xt-rcar
}
