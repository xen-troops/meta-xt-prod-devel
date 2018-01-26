FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Boot all available cores
ATFW_OPT_append = " PSCI_DISABLE_BIGLITTLE_IN_CA57BOOT=0"

BRANCH = "scp_devel"
SRC_URI = "git://github.com/xen-troops/arm-trusted-firmware.git;branch=${BRANCH}"
SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    file://0001-BL2-Disable-TLB-cache-function-of-IPMMU-caches.patch \
"

do_deploy_append () {
    install -m 0644 ${S}/tools/dummy_create/bootparam_sa0.bin ${DEPLOYDIR}/bootparam_sa0.bin
    install -m 0644 ${S}/tools/dummy_create/cert_header_sa6.bin ${DEPLOYDIR}/cert_header_sa6.bin
    install -m 0644 ${S}/tools/dummy_create/cert_header_sa6_emmc.bin ${DEPLOYDIR}/cert_header_sa6_emmc.bin
    install -m 0644 ${S}/tools/dummy_create/cert_header_sa6_emmc.srec ${DEPLOYDIR}/cert_header_sa6_emmc.srec
}

