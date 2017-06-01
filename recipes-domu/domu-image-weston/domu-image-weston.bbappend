FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# these will be populated into the inner build system on do_unpack_xt_extras
XT_QUIRK_UNPACK_SRC_URI += "file://meta-xt-extra;subdir=repo"
# these layers will be added to bblayers.conf on do_configure
XT_QUIRK_BB_ADD_LAYER += "meta-xt-extra"
