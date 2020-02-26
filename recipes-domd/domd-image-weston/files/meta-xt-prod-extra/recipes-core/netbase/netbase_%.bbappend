
do_install_append () {
    if [ ! -z "${AOS_VIS_PLUGINS}" ]; then
	echo "192.168.0.1 wwwivi" >> ${D}${sysconfdir}/hosts
    fi
}
