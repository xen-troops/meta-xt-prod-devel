SUMMARY = "A config file and a run script for a LITMUS-RT domain"
DESCRIPTION = "A config file and a run script for a LITMUS-RT domain"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://domr.cfg \
    file://guest_domr \
"

S = "${WORKDIR}"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domr.cfg \
"

inherit update-rc.d

FILES_${PN}-run += " \
    ${sysconfdir}/init.d/guest_domr \
"

PACKAGES += " \
    ${PN}-run \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run"

INITSCRIPT_NAME_${PN}-run = "guest_domr"
INITSCRIPT_PARAMS_${PN}-run = "defaults 88"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}
    install -m 0744 ${WORKDIR}/domr.cfg ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domr.cfg

    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/guest_domr ${D}${sysconfdir}/init.d/
}
