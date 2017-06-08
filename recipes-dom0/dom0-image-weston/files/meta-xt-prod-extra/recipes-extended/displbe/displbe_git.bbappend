################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " git://github.com/xen-troops/displ_be.git;protocol=https;branch=vgpu-dev"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_DRM=ON -DWITH_ZCOPY=OFF -DWITH_WAYLAND=ON -DWITH_IVI_EXTENSION=OFF -DWITH_INPUT=ON"
