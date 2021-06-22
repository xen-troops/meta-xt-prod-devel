SUMMARY = "Dom0 scripts itended to serve all guests"
DESCRIPTION = "Dom0 scripts itended to serve all guests, or Dom0 itself"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://start_guest.sh \
    file://dom0_vcpu_pin.sh \
    file://xt_set_root_dev_cfg.sh \
"

S = "${WORKDIR}"

DOM0_ALLOWED_PCPUS_salvator-x-m3-xt = "2-5"
DOM0_ALLOWED_PCPUS_salvator-x-h3-xt = "4-7"
DOM0_ALLOWED_PCPUS_salvator-xs-h3-xt = "4-7"
DOM0_ALLOWED_PCPUS_salvator-x-h3-4x2g-xt = "4-7"
DOM0_ALLOWED_PCPUS_salvator-xs-h3-4x2g-xt = "4-7"
DOM0_ALLOWED_PCPUS_m3ulcb-xt = "2-5"
DOM0_ALLOWED_PCPUS_h3ulcb-xt = "4-7"
# Actually M3N SoC doesn't have little CPUs, so allow Dom0 to run on all available CPUs
DOM0_ALLOWED_PCPUS_salvator-xs-m3n-xt = "0-1"
DOM0_ALLOWED_PCPUS_h3ulcb-4x2g-xt = "4-7"
DOM0_ALLOWED_PCPUS_h3ulcb-4x2g-ab-xt = "4-7"
DOM0_ALLOWED_PCPUS_h3ulcb-4x2g-kf-xt = "4-7"
DOM0_ALLOWED_PCPUS_salvator-xs-m3-2x4g-xt = "2-5"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}/start_guest.sh \
"

inherit update-rc.d

FILES_${PN}-run-vcpu_pin += " \
    ${sysconfdir}/init.d/dom0_vcpu_pin.sh \
"

FILES_${PN}-run-set_root_dev += " \
    ${sysconfdir}/init.d/xt_set_root_dev_cfg.sh \
"

PACKAGES += " \
    ${PN}-run-vcpu_pin \
    ${PN}-run-set_root_dev \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run-vcpu_pin ${PN}-run-set_root_dev"

INITSCRIPT_NAME_${PN}-run-vcpu_pin = "dom0_vcpu_pin.sh"
INITSCRIPT_PARAMS_${PN}-run-vcpu_pin = "defaults 81"
# must run before any domain creation
INITSCRIPT_NAME_${PN}-run-set_root_dev = "xt_set_root_dev_cfg.sh"
INITSCRIPT_PARAMS_${PN}-run-set_root_dev = "defaults 82"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}
    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/start_guest.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}/
    install -m 0744 ${WORKDIR}/dom0_vcpu_pin.sh ${D}${sysconfdir}/init.d/
    install -m 0744 ${WORKDIR}/xt_set_root_dev_cfg.sh ${D}${sysconfdir}/init.d/

    # Fixup a number of PCPUs the VCPUs of Dom0 must run on
    sed -i "s/DOM0_ALLOWED_PCPUS/${DOM0_ALLOWED_PCPUS}/g" ${D}${sysconfdir}/init.d/dom0_vcpu_pin.sh
}
