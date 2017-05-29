FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# we need both expand URIs (so THISDIR is set correctly) and append those,
# so first expand and then append
APPEND_XT_QUIRK_UNPACK_SRC_URI := "file://${THISDIR}/files/meta-xt-extra;subdir=repo"
XT_QUIRK_UNPACK_SRC_URI += "${APPEND_XT_QUIRK_UNPACK_SRC_URI}"

# this layers will be added to bblayers.conf
XT_QUIRK_BB_ADD_LAYER += "meta-xt-extra"

do_fetch[depends] += "domu-image-weston:do_${BB_DEFAULT_TASK}"
