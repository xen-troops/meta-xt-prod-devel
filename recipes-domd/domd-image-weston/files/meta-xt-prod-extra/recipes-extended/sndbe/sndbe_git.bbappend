FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " \
    git://github.com/xen-troops/snd_be.git;protocol=https;branch=yocto-v4.7.0-xt0.1 \
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
