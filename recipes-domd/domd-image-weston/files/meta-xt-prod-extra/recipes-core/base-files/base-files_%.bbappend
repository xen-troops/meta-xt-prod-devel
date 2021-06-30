require inc/xt_shared_env.inc

# Append domain name
hostname .= "-domd"

do_install_append () {
	sed -i '/PATH="/a PATH="$PATH:${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}"' ${D}${sysconfdir}/profile
	echo "if [[ -z \${SSH_CONNECTION} ]] ; then" >> ${D}${sysconfdir}/profile
	echo "	shopt -s checkwinsize" >> ${D}${sysconfdir}/profile
	echo "  resize 1> /dev/null" >> ${D}${sysconfdir}/profile
	echo "fi" >> ${D}${sysconfdir}/profile
	if ${@bb.utils.contains('DISTRO_FEATURES', 'vis', 'true', 'false', d)}; then
		echo "192.168.0.1 wwwivi" >> ${D}${sysconfdir}/hosts
	fi
}
