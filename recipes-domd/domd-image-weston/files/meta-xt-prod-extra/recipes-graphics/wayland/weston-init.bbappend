require include/multimedia-control.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {
    sed -i "s/multi-user.target/rc.pvr.service getty.target\nRequires=rc.pvr.service/" \
        ${D}/${systemd_system_unitdir}/weston@.service

    sed -i "s/Conflicts=plymouth-quit.service/Conflicts=plymouth-quit.service getty@tty1.service/" \
        ${D}/${systemd_system_unitdir}/weston@.service

    if echo "${DISTRO_FEATURES}" | grep -qi "ivi-shell"; then
        sed -i '/repaint-window=34/c\repaint-window=34\nshell=ivi-shell.so\nmodules=ivi-controller.so' \
            ${D}/${sysconfdir}/xdg/weston/weston.ini
        sed -e '$a\\' \
            -e '$a\[ivi-shell]' \
            -e '$a\ivi-module=ivi-controller.so' \
            -e '$a\ivi-input-module=ivi-input-controller.so' \
            -e '$a\ivi-id-agent-module=ivi-id-agent.so' \
            -e '$a\transition-duration=300' \
            -e '$a\cursor-theme=default' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
        sed -e '$a\\' \
            -e '$a\[desktop-app-default]' \
            -e '$a\default-surface-id=2000000' \
            -e '$a\default-surface-id-max=2001000' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi
}

do_install_append_r8a7795() {
    if echo "${MACHINEOVERRIDES}" | grep -qi "kingfisher"; then
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=HDMI-A-1' \
            -e '$a\mode=1920x1080@60.0' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=HDMI-A-2' \
            -e '$a\mode=1920x1080' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi

    # H3ULCB has neither HDMI-A-2 nor VGA-1
    if echo "${MACHINEOVERRIDES}" | grep -qi "h3ulcb"; then
        return
    fi

    # DomU based product does need VGA-1 enabled
    if echo "${XT_GUESTS_INSTALL}" | grep -qi "doma";then
        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=VGA-1' \
            -e '$a\mode=off' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi
}

