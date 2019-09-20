FILESEXTRAPATHS_append := "${THISDIR}/files:"

PR="r2"

SRC_URI_append = " \
    file://system.pa \
    file://daemon.conf \
"

SRC_URI_append_h3ulcb-4x2g-kf-xt = " \
    file://rsnddai0ak4613h.conf \
    file://hifi \
    file://system_h3ulcb-4x2g-kf-xt.pa \
    file://pulseaudio-bluetooth.conf \
    file://pulseaudio-ofono.conf \
"

INITSCRIPT_PACKAGES = "${PN}-server"
INITSCRIPT_NAME_${PN}-server = "pulseaudio"
INITSCRIPT_PARAMS_${PN}-server = "defaults 30"

SYSTEM_PA = "system.pa"
SYSTEM_PA_h3ulcb-4x2g-kf-xt = "system_h3ulcb-4x2g-kf-xt.pa"

FILES_${PN}-server += " \
    ${datadir}/alsa/ucm \
    ${datadir}/dbus-1/ \
"

do_install_append () {
    install -d ${D}/etc/pulse

    install -m 0644 ${WORKDIR}/${SYSTEM_PA} ${D}/etc/pulse/system.pa
    install -m 0644 ${WORKDIR}/daemon.conf ${D}/etc/pulse/daemon.conf

    sed -i "/ConditionUser=!root/d" \
    ${D}/${systemd_user_unitdir}/pulseaudio.service

    sed -i "/ConditionUser=!root/d" \
    ${D}/${systemd_user_unitdir}/pulseaudio.socket
}

do_install_append_h3ulcb-4x2g-kf-xt() {
    install -d ${D}/usr/share/alsa/ucm/rsnddai0ak4613h/

    install -m 0644 ${WORKDIR}/rsnddai0ak4613h.conf ${D}${datadir}/alsa/ucm/rsnddai0ak4613h/rsnddai0ak4613h.conf
    install -m 0644 ${WORKDIR}/hifi ${D}${datadir}/alsa/ucm/rsnddai0ak4613h/hifi

    install -d ${D}/${sysconfdir}/dbus-1/system.d
    install -m 644 ${WORKDIR}/pulseaudio-bluetooth.conf ${D}/${sysconfdir}/dbus-1/system.d/
    install -m 644 ${WORKDIR}/pulseaudio-ofono.conf ${D}/${sysconfdir}/dbus-1/system.d/
}

