do_install_append() {
    sed -i "/EnvironmentFile=\-\/etc\/default\/weston/d" \
${D}/${systemd_system_unitdir}/weston.service

    sed -i "s:ExecStart=\/usr\/bin\/weston-start \-v \-e \-\- \-\-idle-time=0 \$OPTARGS:\
ExecStart=\/usr\/bin\/weston-launch \-u root \-\- \-\-idle-time=0 \$OPTARGS:" \
${D}/${systemd_system_unitdir}/weston.service

    sed -i "/ExecStart=\/usr\/bin\/weston-launch \-u root \-\- \-\-idle-time=0 \-\-use-v4l2 \$OPTARGS/a \
ExecStop=\/usr\/bin\/killall \-s KILL weston\n\
Type=simple" \
${D}/${systemd_system_unitdir}/weston.service
}
