FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

EXTRA_OECONF_append = " --enable-ivi-shell"

SRC_URI_append = "file://weston-seats.rules \
                  file://add_screen_remove_layer_API.patch \
"

FILES_${PN} += " \
    ${sysconfdir}/udev/rules.d/weston-seats.rules \
"

do_install_append() {
    sed -e '$a\\' \
        -e '$a\[output]' \
        -e '$a\name=HDMI-A-1' \
        -e '$a\transform=270' \
        -i ${D}/${sysconfdir}/xdg/weston/weston.ini

    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
}

do_install_append_r8a7795() {
    sed -e '$a\\' \
        -e '$a\[output]' \
        -e '$a\name=HDMI-A-2' \
        -e '$a\transform=0' \
        -i ${D}/${sysconfdir}/xdg/weston/weston.ini

    sed -e '$a\\' \
        -e '$a\[output]' \
        -e '$a\name=VGA-1' \
        -e '$a\mode=off' \
        -i ${D}/${sysconfdir}/xdg/weston/weston.ini
}

do_install_append_r8a7796() {
    sed -e '$a\\' \
        -e '$a\[output]' \
        -e '$a\name=VGA-1' \
        -e '$a\transform=270' \
        -i ${D}/${sysconfdir}/xdg/weston/weston.ini
}