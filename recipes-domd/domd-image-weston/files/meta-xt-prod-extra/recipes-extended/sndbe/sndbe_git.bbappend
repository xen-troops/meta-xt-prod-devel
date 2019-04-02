################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "51f29d650690fcb355217f7cd14242212932b855"

SRC_URI_append_rcar = " git://github.com/xen-troops/snd_be.git;protocol=https;branch=master"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_PULSE=ON"

RDEPENDS_${PN} = "libxenbe libconfig pulseaudio-server"
