do_install_append () {
	echo "shopt -s checkwinsize" >> ${D}${sysconfdir}/profile
	echo "resize 1> /dev/null" >> ${D}${sysconfdir}/profile
}
