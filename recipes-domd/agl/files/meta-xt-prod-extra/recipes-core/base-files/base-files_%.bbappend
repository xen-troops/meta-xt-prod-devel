require inc/xt_shared_env.inc

# Append domain name
hostname += "-domd"

do_install_append () {
	sed -i '/PATH="/a PATH="$PATH:${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}"' ${D}${sysconfdir}/profile
}
