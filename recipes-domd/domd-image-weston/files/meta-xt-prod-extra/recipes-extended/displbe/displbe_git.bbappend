################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "d05a59ee3f6caedea32c912f79c7a24c5a53f749"

SRC_URI_append_rcar = " git://github.com/xen-troops/displ_be.git;protocol=https;branch=master"

DEPENDS += " wayland-ivi-extension wayland-native"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_DRM=ON -DWITH_ZCOPY=ON -DWITH_WAYLAND=ON -DWITH_IVI_EXTENSION=ON -DWITH_INPUT=ON"
