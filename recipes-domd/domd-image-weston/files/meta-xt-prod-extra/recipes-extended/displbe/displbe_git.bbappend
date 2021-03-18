FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " \
    git://github.com/xen-troops/displ_be.git;protocol=https;branch=yocto-v4.7.0-xt0.1 \
    file://displbe.service \
"

DEPENDS += " wayland-ivi-extension wayland-native"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_DRM=ON -DWITH_ZCOPY=ON -DWITH_WAYLAND=ON -DWITH_IVI_EXTENSION=ON -DWITH_INPUT=ON"

inherit systemd

SYSTEMD_SERVICE_${PN} = "displbe.service"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/displbe.service ${D}${systemd_system_unitdir}
}

FILES_${PN} += " \
    ${systemd_system_unitdir}/displbe.service \
"