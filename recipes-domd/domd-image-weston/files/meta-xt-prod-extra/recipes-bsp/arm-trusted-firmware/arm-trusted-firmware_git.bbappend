BRANCH = "Rev1.0.20_rev2.xt0.1"
SRC_URI = "git://github.com/xen-troops/arm-trusted-firmware.git;branch=${BRANCH}"
SRCREV = "${AUTOREV}"

do_deploy_append () {
    install -m 0644 ${S}/tools/dummy_create/bootparam_sa0.bin ${DEPLOYDIR}/bootparam_sa0.bin
    install -m 0644 ${S}/tools/dummy_create/cert_header_sa6.bin ${DEPLOYDIR}/cert_header_sa6.bin
    install -m 0644 ${S}/tools/dummy_create/cert_header_sa6_emmc.bin ${DEPLOYDIR}/cert_header_sa6_emmc.bin
    install -m 0644 ${S}/tools/dummy_create/cert_header_sa6_emmc.srec ${DEPLOYDIR}/cert_header_sa6_emmc.srec
}

