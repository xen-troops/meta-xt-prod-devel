require inc/xt_shared_env.inc

do_install_append() {
    sed -i 's/soc/passthrough/g' ${D}/etc/udev/rules.d/72-pvr-seat.rules
}
