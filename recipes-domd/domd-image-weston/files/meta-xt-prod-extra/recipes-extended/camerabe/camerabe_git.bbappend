################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "f149578a5e95e0f630040a3c48a17d06e1df2d9a"

SRC_URI_append_rcar = " git://github.com/xen-troops/camera_be.git;protocol=https;branch=master"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF"

RDEPENDS_${PN} = "libxenbe libconfig libv4l2"
