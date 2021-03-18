FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require inc/xt_shared_env.inc

SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    git://github.com/xen-troops/DisplayManager.git;protocol=https;branch=yocto-v4.7.0-xt0.1 \
    file://display_manager.conf \
    file://display-manager.service \
    file://dm-salvator-x-m3.cfg \
    file://dm-salvator-x-h3.cfg \
    file://dm-ulcb.cfg \
    file://dm-salvator-xs-m3n.cfg \
"

RDEPENDS_${PN} += " dbus-cxx"

EXTRA_OECMAKE_append = " -DWITH_DOC=OFF -DCMAKE_BUILD_TYPE=Release"

DM_CONFIG_salvator-x-m3-xt = "dm-salvator-x-m3.cfg"
DM_CONFIG_salvator-x-h3-xt = "dm-salvator-x-h3.cfg"
DM_CONFIG_salvator-xs-h3-xt = "dm-salvator-x-h3.cfg"
DM_CONFIG_salvator-xs-h3-4x2g-xt = "dm-salvator-x-h3.cfg"
DM_CONFIG_salvator-x-h3-4x2g-xt = "dm-salvator-x-h3.cfg"
DM_CONFIG_ulcb = "dm-ulcb.cfg"
DM_CONFIG_kingfisher_r8a7795 = "dm-salvator-x-h3.cfg"
DM_CONFIG_salvator-xs-m3n-xt = "dm-salvator-xs-m3n.cfg"

inherit systemd

SYSTEMD_SERVICE_${PN} = "display-manager.service"

do_install_append() {
    install -d ${D}${sysconfdir}/dbus-1/system.d
    install -m 0755 ${WORKDIR}/display_manager.conf ${D}${sysconfdir}/dbus-1/system.d/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/display-manager.service ${D}${systemd_system_unitdir}

    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}
    install -m 0744 ${WORKDIR}/${DM_CONFIG} ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}/dm.cfg
}

FILES_${PN} += " \
    ${systemd_system_unitdir}/display-manager.service \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}/dm.cfg \
    ${sysconfdir}/dbus-1/session.d/display_manager.conf \
"
