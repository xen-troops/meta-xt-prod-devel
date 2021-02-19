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
                  file://camera_front.rules \
"

FILES_${PN} += " \
    ${sysconfdir}/udev/rules.d/weston-seats.rules \
    ${sysconfdir}/udev/rules.d/camera_front.rules \
"

do_install_append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
    install -m 0644 ${WORKDIR}/camera_front.rules ${D}${sysconfdir}/udev/rules.d/camera_front.rules
}
