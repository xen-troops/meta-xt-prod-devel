do_install_append () {
    sed -i "/ConditionUser=!root/d" \
    ${D}/${systemd_user_unitdir}/pulseaudio.service

    sed -i "/ConditionUser=!root/d" \
    ${D}/${systemd_user_unitdir}/pulseaudio.socket
}
