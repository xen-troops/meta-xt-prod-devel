SUMMARY = "A config file and a run script for a Fusion domain"
DESCRIPTION = "A config file and a run script for a Fusion domain"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://domf.cfg \
    file://guest_domf \
"

S = "${WORKDIR}"

DOMF_ALLOWED_PCPUS_salvator-x-m3-xt = "2-5"
DOMF_ALLOWED_PCPUS_salvator-x-h3-xt = "4-7"
DOMF_ALLOWED_PCPUS_salvator-xs-h3-xt = "4-7"
DOMF_ALLOWED_PCPUS_salvator-x-h3-4x2g-xt = "4-7"
DOMF_ALLOWED_PCPUS_m3ulcb-xt = "2-5"
DOMF_ALLOWED_PCPUS_h3ulcb-xt = "4-7"
DOMF_ALLOWED_PCPUS_h3ulcb-4x2g-xt = "4-7"
DOMF_ALLOWED_PCPUS_h3ulcb-4x2g-ab-xt = "4-7"
DOMF_ALLOWED_PCPUS_h3ulcb-4x2g-kf-xt = "4-7"
# Actually M3N SoC doesn't have little CPUs, so allow DomF to run on all available CPUs
DOMF_ALLOWED_PCPUS_salvator-xs-m3n-xt = "0-1"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domf.cfg \
"

inherit update-rc.d

FILES_${PN}-run += " \
    ${sysconfdir}/init.d/guest_domf \
"

PACKAGES += " \
    ${PN}-run \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run"

INITSCRIPT_NAME_${PN}-run = "guest_domf"
INITSCRIPT_PARAMS_${PN}-run = "defaults 86"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}
    install -m 0744 ${WORKDIR}/domf.cfg ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domf.cfg

    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/guest_domf ${D}${sysconfdir}/init.d/

    # Fixup a number of PCPUs the VCPUs of DomF must run on
    sed -i "s/DOMF_ALLOWED_PCPUS/${DOMF_ALLOWED_PCPUS}/g" ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domf.cfg
}
