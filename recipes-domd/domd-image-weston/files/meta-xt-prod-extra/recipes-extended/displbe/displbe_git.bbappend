################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " git://github.com/xen-troops/displ_be.git;protocol=https;branch=master"

DEPENDS += " wayland-native"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF -DWITH_DRM=ON -DWITH_ZCOPY=ON -DWITH_WAYLAND=ON -DWITH_INPUT=ON"

USE_IVI_EXTENSION = "${@'1' if 'ivi-shell' in '${DISTRO_FEATURES}' else '0'}"

DEPENDS_append = " \
    ${@base_conditional('USE_IVI_EXTENSION', '1', ' wayland-ivi-extension', '', d)}"

EXTRA_OECMAKE_append_rcar = " \
    ${@base_conditional('USE_IVI_EXTENSION', '1', '', \
        ' -DWITH_IVI_EXTENSION=ON', d)}"

EXTRA_OECMAKE_append_rcar = " \
    ${@base_conditional('USE_IVI_EXTENSION', '0', '', \
        ' -DWITH_IVI_EXTENSION=OFF', d)}"

