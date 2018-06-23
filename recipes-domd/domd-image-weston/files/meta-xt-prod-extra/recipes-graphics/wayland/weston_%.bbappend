FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Only build IVI shell if not building for DomU:
# by default, the product is built with IVI shell for Weston
# which is not needed in case of DomU guest. Check XT_GUESTS_INSTALL
# variable and skip configuration of IVI shell in weston.ini for DomU.
# This is a workaround as display manager and backend are still
# built with ivi-extensions.
python __anonymous () {
    guests = (d.getVar("XT_GUESTS_INSTALL", True) or "").split()
    if "domu" not in guests :
        d.appendVar("EXTRA_OECONF", " --enable-ivi-shell")
}

SRC_URI_append = "file://weston-seats.rules \
                  file://add_screen_remove_layer_API.patch \
"

FILES_${PN} += " \
    ${sysconfdir}/udev/rules.d/weston-seats.rules \
"

do_install_append_r8a7795() {
    # DomU based product doesn't need transform
    if echo "${XT_GUESTS_INSTALL}" | grep -qi "domu";then
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=HDMI-A-1' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    else
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=HDMI-A-1' \
            -e '$a\transform=270' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi

    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
}

do_install_append_r8a7795() {
    sed -e '$a\\' \
        -e '$a\[output]' \
        -e '$a\name=HDMI-A-2' \
        -e '$a\transform=0' \
        -i ${D}/${sysconfdir}/xdg/weston/weston.ini

    # DomU based product does need VGA-1 enabled
    if echo "${XT_GUESTS_INSTALL}" | grep -qi "domu";then
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=VGA-1' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    else
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=VGA-1' \
            -e '$a\mode=off' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi
}

do_install_append_r8a7796() {
    sed -e '$a\\' \
        -e '$a\[output]' \
        -e '$a\name=HDMI-A-1' \
        -i ${D}/${sysconfdir}/xdg/weston/weston.ini

    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
}

do_install_append_r8a7796() {
    # DomU based product doesn't need transform
    if echo "${XT_GUESTS_INSTALL}" | grep -qi "domu";then
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=VGA-1' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    else
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=VGA-1' \
            -e '$a\transform=${TRANSFORM}' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi
}