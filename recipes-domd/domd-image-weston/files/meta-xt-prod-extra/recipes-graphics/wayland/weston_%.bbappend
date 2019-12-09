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

SRC_URI_IVI_ID_AGENT = " \
    file://0001-ivi-shell-rework-goto-labels-to-avoid-memory-leaks.patch \
    file://0002-ivi-shell-removed-assert.patch \
    file://0003-ivi-shell-introduction-of-IVI_INVALID_ID.patch \
    file://0004-layout-interface-added-interface-to-change-surface-i.patch \
    file://0005-ivi-layout-introduced-configure_desktop_changed.patch \
    file://0006-ivi-layout-introduced-surface-create-and-configure.patch \
    file://0007-ivi-shell-linked-libweston-desktop-and-added-structs.patch \
    file://0008-ivi-layout-use-libweston-desktop-api-for-views.patch \
    file://0009-ivi-shell-added-libweston-desktop-api-implementation.patch \
    file://0010-ivi-shell-remove-surface_destroy_listener.patch \
    file://0011-ivi-shell-create-weston_desktop-in-wet_shell_init.patch \
    file://0012-hmi-controller-register-for-desktop_surface_configur.patch \
    file://0013-simple-egl-remove-ivi-application-support.patch \
    file://0014-simple-shm-remove-ivi-application-support.patch \
    file://0015-window-client-remove-ivi-application-support.patch \
"

SRC_URI_append = "file://weston-seats.rules \
                  file://weston-seats-kf.rules \
                  ${@bb.utils.contains('DISTRO_FEATURES', 'ivi-shell', SRC_URI_IVI_ID_AGENT, '', d)} \
"

FILES_${PN} += " \
    ${sysconfdir}/udev/rules.d/weston-seats.rules \
"

do_install_append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
}

do_install_append_kingfisher() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats-kf.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
}
