FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require inc/xt_shared_env.inc

DESCRIPTION = "virtio-disk"
SECTION = "extras"
LICENSE = "GPLv2"
PR = "r0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

S = "${WORKDIR}/git"

DEPENDS = "xen-tools"

SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    git://github.com/xen-troops/virtio-disk.git;protocol=https;branch=ioreq_ml3 \
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
