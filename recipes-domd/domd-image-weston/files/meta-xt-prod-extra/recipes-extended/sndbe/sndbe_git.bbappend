FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "b2764c2849f02c051f1d16dc6b592da59d1675c1"

SRC_URI_append_rcar = " \
    git://github.com/xen-troops/snd_be.git;protocol=https;branch=master \
    file://sndbe.service \
"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_PULSE=ON"

RDEPENDS_${PN} = "libxenbe libconfig pulseaudio-server"

inherit systemd

SYSTEMD_SERVICE_${PN} = "sndbe.service"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/sndbe.service ${D}${systemd_system_unitdir}
}

FILES_${PN} += " \
    ${systemd_system_unitdir}/sndbe.service \
"
