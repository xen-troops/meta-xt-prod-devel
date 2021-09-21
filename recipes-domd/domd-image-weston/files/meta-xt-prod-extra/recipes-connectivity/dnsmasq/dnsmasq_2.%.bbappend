FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://depend.conf \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/system/dnsmasq.service.d/depend.conf \
"

do_install_append() {
    # Make dnsmasq listen only on bridge interface
    echo "interface=xenbr0" >> ${D}${sysconfdir}/dnsmasq.conf

    # Define DHCP leases range. Upper part of subnet can be used
    # for static configuration.
    echo "dhcp-range=192.168.0.2,192.168.0.150,12h" >> ${D}${sysconfdir}/dnsmasq.conf

    # Configure IP addresses for DomF, DomA, DomU.
    # MAC addresses are defined in /xt/dom.cfg/dom?.cfg
    if ${@bb.utils.contains('XT_GUESTS_INSTALL', 'domf', 'true', 'false', d)}; then
        echo "dhcp-host=08:00:27:ff:cb:cd,domf,192.168.0.3,infinite" >> ${D}${sysconfdir}/dnsmasq.conf
    fi
    if ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'true', 'false', d)}; then
        echo "dhcp-host=08:00:27:ff:cb:ce,doma,192.168.0.4,infinite" >> ${D}${sysconfdir}/dnsmasq.conf
    fi
    if ${@bb.utils.contains('XT_GUESTS_INSTALL', 'domu', 'true', 'false', d)}; then
        echo "dhcp-host=08:00:27:ff:cb:cf,domu,192.168.0.5,infinite" >> ${D}${sysconfdir}/dnsmasq.conf
    fi

    # Use resolve.conf provided by systemd-resolved
    echo "resolv-file=/run/systemd/resolve/resolv.conf" >> ${D}${sysconfdir}/dnsmasq.conf

    # Add actual dependencies
    install -d ${D}${sysconfdir}/systemd/system/dnsmasq.service.d
    install -m 0644 ${WORKDIR}/depend.conf ${D}${sysconfdir}/systemd/system/dnsmasq.service.d/
}
