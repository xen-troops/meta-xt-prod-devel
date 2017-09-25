do_install_append() {
    sed -i '/repaint-window=34/c\idle-time=0\nrepaint-window=34' \
        ${D}/${sysconfdir}/xdg/weston/weston.ini
}
