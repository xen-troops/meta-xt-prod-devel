SUMMARY = "config files and scripts for a Weston guest"
DESCRIPTION = "config files and scripts for guest which will be running for tests"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://domu-salvator-x-m3.cfg \
    file://domu-salvator-x-h3.cfg \
    file://domu-salvator-x-m3n.cfg \
    file://domu-salvator-x-h3-4x2g.cfg \
    file://guest_domu \
"

S = "${WORKDIR}"

DOMU_CONFIG_salvator-x-m3-xt = "domu-salvator-x-m3.cfg"
DOMU_CONFIG_salvator-x-h3-xt = "domu-salvator-x-h3.cfg"
DOMU_CONFIG_salvator-x-m3n-xt = "domu-salvator-x-m3n.cfg"
DOMU_CONFIG_salvator-x-h3-4x2g-xt = "domu-salvator-x-h3-4x2g.cfg"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg \
"

inherit update-rc.d

FILES_${PN}-run += " \
    ${sysconfdir}/init.d/guest_domu \
"

PACKAGES += " \
    ${PN}-run \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run"

INITSCRIPT_NAME_${PN}-run = "guest_domu"
INITSCRIPT_PARAMS_${PN}-run = "defaults 87"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}
    install -m 0744 ${WORKDIR}/${DOMU_CONFIG} ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg

    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/guest_domu ${D}${sysconfdir}/init.d/

}
