FILESEXTRAPATHS_append := "${THISDIR}/files:"

PR="r2"

SRC_URI_append = " \
    file://system.pa \
    file://daemon.conf \
    file://pulseaudio.service \
"

SRC_URI_append_h3ulcb-4x2g-kf-xt = " \
    file://rsnddai0ak4613h.conf \
    file://hifi \
    file://pulseaudio-bluetooth.conf \
    file://pulseaudio-ofono.conf \
"

inherit systemd

INITSCRIPT_PACKAGES = "${PN}-server"
INITSCRIPT_NAME_${PN}-server = "pulseaudio"
INITSCRIPT_PARAMS_${PN}-server = "defaults 30"

FILES_${PN}-server += " \
    ${datadir}/alsa/ucm \
    ${datadir}/dbus-1/ \
"

FILES_${PN} = " \
    ${systemd_system_unitdir} \
"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = " pulseaudio.service"

set_cfg_value () {
	sed -i -e "s~\(; *\)\?$2 =.*~$2 = $3~" "$1"
	if ! grep -q "^$2 = $3\$" "$1"; then
		die "Use of sed to set '$2' to '$3' in '$1' failed"
	fi
}

do_install_append () {
    install -d ${D}/etc/pulse

    install -m 0644 ${WORKDIR}/system.pa ${D}/etc/pulse/system.pa
    install -m 0644 ${WORKDIR}/daemon.conf ${D}/etc/pulse/daemon.conf

    rm -rf ${D}/usr/lib/systemd
    rm ${D}/${sysconfdir}/pulse/default.pa

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/pulseaudio.service ${D}${systemd_system_unitdir} 

    set_cfg_value ${D}/${sysconfdir}/pulse/client.conf autospawn no
    set_cfg_value ${D}/${sysconfdir}/pulse/client.conf default-server /var/run/pulse/native
}

do_install_append_h3ulcb-4x2g-kf-xt() {
    install -d ${D}/usr/share/alsa/ucm/rsnddai0ak4613h/

    install -m 0644 ${WORKDIR}/rsnddai0ak4613h.conf ${D}${datadir}/alsa/ucm/rsnddai0ak4613h/rsnddai0ak4613h.conf
    install -m 0644 ${WORKDIR}/hifi ${D}${datadir}/alsa/ucm/rsnddai0ak4613h/hifi

    install -d ${D}/${sysconfdir}/dbus-1/system.d
    install -m 644 ${WORKDIR}/pulseaudio-bluetooth.conf ${D}/${sysconfdir}/dbus-1/system.d/
    install -m 644 ${WORKDIR}/pulseaudio-ofono.conf ${D}/${sysconfdir}/dbus-1/system.d/
}

