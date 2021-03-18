FILESEXTRAPATHS_append := "${THISDIR}/files:"

SRC_URI_append = " \
    file://0001-install-wayland.h-header.patch \
    file://0002-pkgconfig-libgstwayland.patch \
    file://0003-gstkmssink-add-rcar-du-to-driver-list.patch \
"

PACKAGECONFIG_append = " kms"
