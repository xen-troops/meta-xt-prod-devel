SUMMARY = "Data and service files for aos_servicemanager"
DESCRIPTION = "Data and service files for aos_servicemanager which will be using for tests"

PV = "0.1"
LICENSE = "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV = "${AUTOREV}"
SRC_URI = "git://git@gitpct.epam.com/epmd-aepr/aos_servicemanager.git;protocol=ssh;branch=master"
S = "${WORKDIR}/git"

SRC_URI += " \
    file://aos_servicemanager.service \
    file://fcrypt.json \
"

inherit systemd

PACKAGES += " \
    ${PN}-aos-servicemanager-service \
"

SYSTEMD_PACKAGES = " \
    ${PN}-aos-servicemanager-service \ 
"

SYSTEMD_SERVICE_${PN}-aos-servicemanager-service = " aos_servicemanager.service"

FILES_${PN}-aos-servicemanager-service = " \
    ${systemd_system_unitdir}/aos_servicemanager.service \
"
do_install() {
    install -d ${D}/var/aos/fcrypt
    install -m 0644 ${WORKDIR}/fcrypt.json ${D}/var/aos

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}

    install -m 0644 ${S}/data/fcrypt/* ${D}/var/aos/fcrypt
}

FILES_${PN} = " \
    /var/aos/*.json \
    /var/aos/fcrypt/* \
"

