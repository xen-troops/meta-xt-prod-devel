FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../recipes-domx:"

# we need MACHINEOVERRIDES from DomD build
do_configure[depends] += "domd-image-weston:do_domd_install_machine_overrides"

SRC_URI = " \
    repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=prod_devel/domu_android_host_tools.xml;scmdata=keep \
"

XT_BB_LAYERS_FILE = "meta-xt-prod-extra/doc/bblayers.conf.domu-image-android"
XT_BB_LOCAL_CONF_FILE = "meta-xt-prod-extra/doc/local.conf.domu-image-android"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# these will be populated into the inner build system on do_unpack_xt_extras
XT_QUIRK_UNPACK_SRC_URI += "\
    file://meta-xt-prod-extra;subdir=repo \
    file://meta-xt-prod-domx;subdir=repo \
"

# these layers will be added to bblayers.conf on do_configure
XT_QUIRK_BB_ADD_LAYER += " \
    meta-xt-prod-extra \
    meta-xt-prod-domx \
"

XT_BB_IMAGE_TARGET = "android"

