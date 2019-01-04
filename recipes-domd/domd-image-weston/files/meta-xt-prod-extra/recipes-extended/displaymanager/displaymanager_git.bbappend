FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    git://github.com/xen-troops/DisplayManager.git;protocol=https;branch=master \
    file://display_manager.conf \
"

RDEPENDS_${PN} += " dbus-cpp"

EXTRA_OECMAKE_append = " -DWITH_DOC=OFF -DCMAKE_BUILD_TYPE=Release"

do_install_append() {
    install -d ${D}${sysconfdir}/dbus-1/session.d
    install -m 0755 ${WORKDIR}/display_manager.conf ${D}${sysconfdir}/dbus-1/session.d/
}

FILES_${PN} += " \
    ${sysconfdir}/dbus-1/session.d/display_manager.conf \
"
