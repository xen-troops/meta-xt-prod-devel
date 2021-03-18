FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require inc/xt_shared_env.inc

################################################################################
# Renesas R-Car
################################################################################
SRCREV_rcar = "${AUTOREV}"

SRC_URI_append_rcar = " \
    git://github.com/xen-troops/camera_be.git;protocol=https;branch=yocto-v4.7.0-xt0.1 \
    file://camerabe.service \
    file://camera_be.cfg \
"

EXTRA_OECMAKE_append_rcar = " -DWITH_DOC=OFF"

RDEPENDS_${PN} = "libxenbe libconfig libv4l media-ctl v4l-utils"

inherit systemd

SYSTEMD_SERVICE_${PN} = "camerabe.service"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/camerabe.service ${D}${systemd_system_unitdir}

    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}
    install -m 0744 ${WORKDIR}/camera_be.cfg ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}/camera_be.cfg
}

FILES_${PN} += " \
    ${systemd_system_unitdir}/camerabe.service \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}/camera_be.cfg \
"
