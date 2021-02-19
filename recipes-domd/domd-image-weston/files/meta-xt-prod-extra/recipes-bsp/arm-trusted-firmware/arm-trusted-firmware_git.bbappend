FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://0001-rcar-Use-UART-instead-of-Secure-DRAM-area-for-loggin.patch \
    file://0002-tools-Produce-two-cert_header_sa6-images.patch \
    file://0003-rcar-Add-BOARD_SALVATOR_X-case-in-ddr_rank_judge.patch \
"

do_deploy_append () {
    install -m 0644 ${S}/tools/renesas/rcar_layout_create/bootparam_sa0.bin ${DEPLOYDIR}/bootparam_sa0.bin
    install -m 0644 ${S}/tools/renesas/rcar_layout_create/cert_header_sa6.bin ${DEPLOYDIR}/cert_header_sa6.bin
    install -m 0644 ${S}/tools/renesas/rcar_layout_create/cert_header_sa6_emmc.bin ${DEPLOYDIR}/cert_header_sa6_emmc.bin
    install -m 0644 ${S}/tools/renesas/rcar_layout_create/cert_header_sa6_emmc.srec ${DEPLOYDIR}/cert_header_sa6_emmc.srec
}

