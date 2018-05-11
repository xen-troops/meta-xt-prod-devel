LICENSE = "CLOSED"

# FIXME: if not forced and sstate cache is used then an old version of
# this package (read old DomU kernel images) can be used from cache
# regardless of the fact that binaries may have actually changed, e.g.
# the recipe code is not changed, there is no SRC_URI with checksum
# force install so if DomU kernel changes we use the latest binaries
do_install[nostamp] = "1"
do_install() {
     install -d ${XT_SHARED_ROOTFS_DIR}
     echo "MACHINEOVERRIDES .= \":${MACHINEOVERRIDES}\"" > "${XT_SHARED_ROOTFS_DIR}/local.conf.domd_machine.inc"
}

