FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " \
    git://github.com/xen-troops/camera_be.git;protocol=https;branch=master \
    file://camerabe.service \
"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF"

RDEPENDS_${PN} = "libxenbe libconfig libv4l"

inherit systemd

SYSTEMD_SERVICE_${PN} = "camerabe.service"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/camerabe.service ${D}${systemd_system_unitdir}
}

FILES_${PN} += " \
    ${systemd_system_unitdir}/camerabe.service \
"
