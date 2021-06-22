SUMMARY = "A config file and a run script for a Driver domain"
DESCRIPTION = "A config file and a run script for a Driver domain"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://domd-m3ulcb.cfg \
    file://domd-h3ulcb.cfg \
    file://domd-salvator-x-m3.cfg \
    file://domd-salvator-x-h3.cfg \
    file://domd-salvator-xs-h3.cfg \
    file://domd-salvator-xs-h3-4x2g.cfg \
    file://domd-salvator-x-h3-4x2g.cfg \
    file://domd-salvator-xs-m3n.cfg \
    file://domd-h3ulcb-4x2g.cfg \
    file://domd-h3ulcb-4x2g-ab.cfg \
    file://domd-h3ulcb-4x2g-kf.cfg \
    file://domd-salvator-xs-m3-2x4g.cfg \
    file://guest_domd \
"

S = "${WORKDIR}"

DOMD_CONFIG_salvator-x-m3-xt = "domd-salvator-x-m3.cfg"
DOMD_CONFIG_salvator-x-h3-xt = "domd-salvator-x-h3.cfg"
DOMD_CONFIG_salvator-xs-h3-xt = "domd-salvator-xs-h3.cfg"
DOMD_CONFIG_salvator-xs-h3-4x2g-xt = "domd-salvator-xs-h3-4x2g.cfg"
DOMD_CONFIG_salvator-x-h3-4x2g-xt = "domd-salvator-x-h3-4x2g.cfg"
DOMD_CONFIG_m3ulcb-xt = "domd-m3ulcb.cfg"
DOMD_CONFIG_h3ulcb-xt = "domd-h3ulcb.cfg"
DOMD_CONFIG_salvator-xs-m3n-xt = "domd-salvator-xs-m3n.cfg"
DOMD_CONFIG_h3ulcb-4x2g-xt = "domd-h3ulcb-4x2g.cfg"
DOMD_CONFIG_h3ulcb-4x2g-ab-xt = "domd-h3ulcb-4x2g-ab.cfg"
DOMD_CONFIG_h3ulcb-4x2g-kf-xt = "domd-h3ulcb-4x2g-kf.cfg"
DOMD_CONFIG_salvator-xs-m3-2x4g-xt = "domd-salvator-xs-m3-2x4g.cfg"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domd.cfg \
"

inherit update-rc.d

FILES_${PN}-run += " \
    ${sysconfdir}/init.d/guest_domd \
"

PACKAGES += " \
    ${PN}-run \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run"

INITSCRIPT_NAME_${PN}-run = "guest_domd"
INITSCRIPT_PARAMS_${PN}-run = "defaults 85"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}
    install -m 0744 ${WORKDIR}/${DOMD_CONFIG} ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domd.cfg

    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/guest_domd ${D}${sysconfdir}/init.d/

    if ${@bb.utils.contains('DISTRO_FEATURES', 'virtio', 'true', 'false', d)}; then
        # Increase XT page pool
        sed -i 's/xt_page_pool=67108864/xt_page_pool=603979776/' \
        ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domd.cfg
    fi
}
