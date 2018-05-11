FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    file://display_manager.conf \
"
FILES_${PN} += " \
    ${datadir}/dbus-1/session.d/display_manager.conf \
"

do_install_append() {
    install -d ${D}${sysconfdir}/dbus-1/session.d
    install -m 0755 ${WORKDIR}/display_manager.conf ${D}${sysconfdir}/dbus-1/session.d/
}

