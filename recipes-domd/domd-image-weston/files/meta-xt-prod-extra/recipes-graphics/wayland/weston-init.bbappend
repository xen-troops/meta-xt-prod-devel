do_install_append() {
    sed -i "s/After=dbus.service multi-user.target/After=dbus.service rc.pvr.service/" \
${D}/${systemd_system_unitdir}/weston.service
}
