# FIXME: this is rather a workaround then fix
# this must be added to conf/distro/include/meta_oe_security_flags.inc 
SECURITY_CFLAGS_pn-libconfig = "${SECURITY_NO_PIE_CFLAGS}"
