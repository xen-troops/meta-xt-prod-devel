FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

BRANCH = "1.9/4813199-ces2018"
SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    file://0001-EGL-eglext.h-Include-eglmesaext.h.patch \
"

