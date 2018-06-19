SUMMARY = "Data and service files for aos_servicemanager"
DESCRIPTION = "Data and service files for aos_servicemanager which will be used for tests"

PV = "0.1"
LICENSE = "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "git://git@gitpct.epam.com/epmd-aepr/aos_servicemanager.git;protocol=ssh;branch=master;tag=demo_0.1"
S = "${WORKDIR}/git"

SRC_URI += " \
    file://aos_servicemanager.service \
    file://fcrypt.json \
    file://eth0.network \
    file://hosts \
"

FILES_${PN}-net-config = " \
    ${sysconfdir}/systemd/network/eth0.network \
"

inherit systemd

PACKAGES += " \
    ${PN}-aos-servicemanager-service \
    ${PN}-net-config \
"

SYSTEMD_PACKAGES = " \
    ${PN}-aos-servicemanager-service \
"

RDEPENDS_${PN} = " \
    ${PN}-aos-servicemanager-service \
    ${PN}-net-config \
"

SYSTEMD_SERVICE_${PN}-aos-servicemanager-service = " aos_servicemanager.service"

FILES_${PN}-aos-servicemanager-service = " \
    ${systemd_system_unitdir}/aos_servicemanager.service \
"

do_install() {
    install -d ${D}/var/aos/fcrypt
    install -m 0644 ${WORKDIR}/fcrypt.json ${D}/var/aos

    install -d ${D}/var/aos/data
    install -d ${D}/var/aos/data/etc
    install -m 0644 ${WORKDIR}/hosts ${D}/var/aos/data/etc

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}


    install -m 0644 ${S}/data/fcrypt/* ${D}/var/aos/fcrypt

    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/*.network ${D}${sysconfdir}/systemd/network
}

FILES_${PN} = " \
    /var/aos/*.json \
    /var/aos/fcrypt/* \
    /var/aos/data/etc/hosts \
"

