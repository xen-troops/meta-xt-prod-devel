################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " git://github.com/xen-troops/snd_be.git;protocol=https;branch=master"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_PULSE=ON"

RDEPENDS_${PN} = "libxenbe libconfig pulseaudio-server"
