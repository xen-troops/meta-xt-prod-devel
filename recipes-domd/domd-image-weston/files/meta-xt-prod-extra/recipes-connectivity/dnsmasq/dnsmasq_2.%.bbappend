FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://depend_resolved.conf \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/system/dnsmasq.service.d/depend_resolved.conf \
"

do_install_append() {
    # Make dnsmasq listen only on bridge interface
    echo "interface=xenbr0" >> ${D}${sysconfdir}/dnsmasq.conf

    # Define DHCP leases range. Upper part of subnet can be used
    # for static configuration.
    echo "dhcp-range=192.168.0.2,192.168.0.150,12h" >> ${D}${sysconfdir}/dnsmasq.conf

    # Configure addresses for DomF and DomA. Mac addresses
    # are the same as in /xt/conf/*.conf
    echo "dhcp-host=08:00:27:ff:cb:cd,domf,192.168.0.3,infinite" >> ${D}${sysconfdir}/dnsmasq.conf
    echo "dhcp-host=08:00:27:ff:cb:ce,doma,192.168.0.4,infinite" >> ${D}${sysconfdir}/dnsmasq.conf

    # Use resolve.conf provided by systemd-resolved
    echo "resolv-file=/run/systemd/resolve/resolv.conf" >> ${D}${sysconfdir}/dnsmasq.conf

    # Add dependency on systemd-resolved
    install -d ${D}${sysconfdir}/systemd/system/dnsmasq.service.d
    install -m 0644 ${WORKDIR}/depend_resolved.conf ${D}${sysconfdir}/systemd/system/dnsmasq.service.d/
}
