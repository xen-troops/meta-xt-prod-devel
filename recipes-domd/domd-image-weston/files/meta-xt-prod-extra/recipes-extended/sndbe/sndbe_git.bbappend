################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "f25453f6dd63652958227652d20a01b7627ca141"

SRC_URI_append_rcar = " git://github.com/xen-troops/snd_be.git;protocol=https;branch=master"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_PULSE=ON"

RDEPENDS_${PN} = "libxenbe libconfig pulseaudio-server"
