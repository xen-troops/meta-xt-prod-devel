FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://main.conf \
    file://disable_dns_proxy.conf \
"

FILES_${PN} += " \
    ${sysconfdir}/main.conf \
    ${sysconfdir}/systemd/system/connman.service.d/disable_dns_proxy.conf \
"

do_install_append() {
    install -d ${D}${sysconfdir}/connman
    install -m 0644 ${WORKDIR}/main.conf ${D}${sysconfdir}/connman/main.conf

    install -d ${D}${sysconfdir}/systemd/system/connman.service.d
    install -m 0644 ${WORKDIR}/disable_dns_proxy.conf ${D}${sysconfdir}/systemd/system/connman.service.d/
}

