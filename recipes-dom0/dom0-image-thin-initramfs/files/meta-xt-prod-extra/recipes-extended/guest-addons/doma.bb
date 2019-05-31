SUMMARY = "A config file and a run script for an Android domain"
DESCRIPTION = "A config file and a run script for an Android domain"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://doma-salvator-generic.cfg \
    file://doma-salvator-x-h3-4x2g.cfg \
    file://guest_doma \
"

S = "${WORKDIR}"

DOMA_CONFIG = "doma-salvator-generic.cfg"
DOMA_CONFIG_salvator-x-h3-4x2g-xt = "doma-salvator-x-h3-4x2g.cfg"
DOMA_CONFIG_salvator-xs-h3-4x2g-xt = "doma-salvator-x-h3-4x2g.cfg"
DOMA_CONFIG_h3ulcb-4x2g-xt = "doma-salvator-x-h3-4x2g.cfg"
DOMA_CONFIG_h3ulcb-4x2g-kf-xt = "doma-salvator-x-h3-4x2g.cfg"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg \
"

inherit update-rc.d

FILES_${PN}-run += " \
    ${sysconfdir}/init.d/guest_doma \
"

PACKAGES += " \
    ${PN}-run \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run"

INITSCRIPT_NAME_${PN}-run = "guest_doma"
INITSCRIPT_PARAMS_${PN}-run = "defaults 87"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}
    install -m 0744 ${WORKDIR}/${DOMA_CONFIG} ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg

    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/guest_doma ${D}${sysconfdir}/init.d/

}
