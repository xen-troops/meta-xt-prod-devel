################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

DEPENDS += " xen-tools"

SRC_URI_append_rcar = " git://github.com/xen-troops/libxenbe.git;protocol=https;branch=master"
