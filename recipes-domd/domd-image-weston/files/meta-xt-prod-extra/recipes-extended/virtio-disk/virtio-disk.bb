FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require inc/xt_shared_env.inc

DESCRIPTION = "virtio-disk"
SECTION = "extras"
LICENSE = "GPLv2"
PR = "r0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

S = "${WORKDIR}/git"

DEPENDS = "xen"

SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    git://git@gitpct.epam.com/Oleksandr_Tyshchenko/demu.git;protocol=ssh;branch=ioreq_v2 \
    file://virtio-disk.service \
"

inherit systemd pkgconfig autotools-brokensep

SYSTEMD_SERVICE_${PN} = "virtio-disk.service"

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/virtio-disk.service ${D}${systemd_system_unitdir}
}

FILES_${PN} += " \
    ${systemd_system_unitdir}/virtio-disk.service \
"
