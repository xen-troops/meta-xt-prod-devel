FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# we need both expand URIs (so THISDIR is set correctly) and append those,
# so first expand and then append
# these will be populated into the inner build system on do_unpack_xt_extras
APPEND_XT_QUIRK_UNPACK_SRC_URI := "file://${THISDIR}/files/meta-xt-extra;subdir=repo"
XT_QUIRK_UNPACK_SRC_URI += "${APPEND_XT_QUIRK_UNPACK_SRC_URI}"
# this layers will be added to bblayers.conf on do_configure
XT_QUIRK_BB_ADD_LAYER += "meta-xt-extra"