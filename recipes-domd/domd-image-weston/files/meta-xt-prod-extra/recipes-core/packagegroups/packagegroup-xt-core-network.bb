SUMMARY = "DomD networking components"

LICENSE = "MIT"

inherit packagegroup

RDEPENDS_packagegroup-xt-core-network = "\
    guest-addons-bridge-up-notification-service \
    guest-addons-bridge-config \
    dnsmasq \
    nftables \
    ntpdate-systemd \
    tzdata \
"
