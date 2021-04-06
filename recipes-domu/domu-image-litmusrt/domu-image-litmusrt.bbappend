# these layers will be added to bblayers.conf on do_configure
XT_QUIRK_BB_ADD_LAYER += " \
    meta-litmusrt \
"

SRC_URI = " \
    repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=prod_devel/domr.xml;scmdata=keep \
"

SRCREV = "${AUTOREV}"

configure_versions_base() {
    local local_conf="${S}/build/conf/local.conf"

    cd ${S}
    # override what xt-distro wants as machine as we don't depend on HW
    base_update_conf_value ${local_conf} MACHINE "generic-armv8-xt"
    base_update_conf_value ${local_conf} SERIAL_CONSOLE "115200 hvc0"
    base_update_conf_value ${local_conf} "PREFERRED_PROVIDER_virtual/kernel" "linux-litmusrt"
}

python do_configure_append() {
    bb.build.exec_func("configure_versions_base", d)
}

################################################################################
# Generic
################################################################################
XT_BB_IMAGE_TARGET = "litmusrt-image-minimal"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../recipes-domx:"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# these will be populated into the inner build system on do_unpack_xt_extras
XT_QUIRK_UNPACK_SRC_URI += "\
    file://meta-xt-prod-extra;subdir=repo \
    file://meta-xt-prod-domx;subdir=repo \
"

XT_QUIRK_BB_ADD_LAYER += " \
    meta-xt-prod-extra \
    meta-xt-prod-domx \
"

