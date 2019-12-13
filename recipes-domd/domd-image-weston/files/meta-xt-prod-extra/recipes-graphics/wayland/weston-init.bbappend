require include/multimedia-control.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI = " \
    file://init \
    file://weston.service \
    file://weston-start \
"

do_install_append() {
    # Install weston-start script
    install -Dm755 ${WORKDIR}/weston-start ${D}${bindir}/weston-start
    sed -i 's,@DATADIR@,${datadir},g' ${D}${bindir}/weston-start
    sed -i 's,@LOCALSTATEDIR@,${localstatedir},g' ${D}${bindir}/weston-start

    sed -i "s/After=dbus.service multi-user.target/After=dbus.service rc.pvr.service/" \
        ${D}/${systemd_system_unitdir}/weston.service

    if [ "X${USE_MULTIMEDIA}" = "X1" -a "X${USE_V4L2_RENDERER}" = "X1" ]; then
        sed -e "s/\$OPTARGS/--use-v4l2 \$OPTARGS/" \
            -i ${D}/${systemd_system_unitdir}/weston.service
    fi
}
