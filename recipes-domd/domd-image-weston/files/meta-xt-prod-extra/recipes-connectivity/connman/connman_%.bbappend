FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://main.conf \
    file://disable_dns_proxy.conf \
    file://0001-disable-when-booting-over-nfs-rebased.patch \
"

# Do not stop systemd-resolved service when we use connman as network manager.
SRC_URI_remove = " \
    file://0001-connman.service-stop-systemd-resolved-when-we-use-co.patch \
    file://0001-disable-when-booting-over-nfs.patch \
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

