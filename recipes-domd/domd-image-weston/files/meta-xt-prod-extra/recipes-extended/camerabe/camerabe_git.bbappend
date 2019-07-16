################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " git://github.com/xen-troops/camera_be.git;protocol=https;branch=master"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF"

RDEPENDS_${PN} = "libxenbe libconfig libv4l2"
