do_install_append_r8a7795() {
    if echo "${DISTRO_FEATURES}" | grep -qi "ivi-shell"; then
        sed -i '/repaint-window=34/c\repaint-window=34\nshell=ivi-shell.so\nmodules=ivi-controller.so' \
            ${D}/${sysconfdir}/xdg/weston/weston.ini
        sed -e '$a\\' \
            -e '$a\[ivi-shell]' \
            -e '$a\ivi-module=ivi-controller.so' \
            -e '$a\ivi-input-module=ivi-input-controller.so' \
            -e '$a\transition-duration=300' \
            -e '$a\cursor-theme=default' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi

    if echo "${DISTRO_FEATURES}" | grep -qi "v4l2-renderer"; then
        sed -e '$a\\' \
            -e '$a\[v4l2-renderer]' \
            -e '$a\device=/dev/media1' \
            -e '$a\device-module=vsp2' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi

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
            -e '$a\transform=0' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi

    if echo "${MACHINEOVERRIDES}" | grep -qi "kingfisher"; then
        sed -i '/name=HDMI\-A\-1/a mode=1920x1080@60.0' \
        ${D}/${sysconfdir}/xdg/weston/weston.ini

        sed -e '$a\\' \
            -e '$a\[output]' \
            -e '$a\name=HDMI-A-2' \
            -e '$a\mode=1920x1080' \
            -e '$a\transform=0' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi

    # H3ULCB has neither HDMI-A-2 nor VGA-1
    if echo "${MACHINEOVERRIDES}" | grep -qi "h3ulcb"; then
        return
    fi

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
            -e '$a\transform=0' \
            -i ${D}/${sysconfdir}/xdg/weston/weston.ini
    fi
}
