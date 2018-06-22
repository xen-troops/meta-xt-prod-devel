FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

BRANCH = "1.9/4991288"
SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    file://0001-EGL-eglext.h-Include-eglmesaext.h.patch \
    file://GLES-gl3ext.h.patch \
"

do_install_append() {
    install -d ${DEPLOY_DIR_IMAGE}/xt-rcar
    cp -rf ${D}/* ${DEPLOY_DIR_IMAGE}/xt-rcar
}
