FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

EXTRA_OECONF_append = " --enable-ivi-shell"

SRC_URI_append = "file://weston-seats.rules \
                  file://add_screen_remove_layer_API.patch \
"

FILES_${PN} += " \
    ${sysconfdir}/udev/rules.d/weston-seats.rules \
"

do_install_append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
}
