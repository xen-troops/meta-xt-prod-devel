FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../recipes-domx:"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# these will be populated into the inner build system on do_unpack_xt_extras
XT_QUIRK_UNPACK_SRC_URI += " \
    file://meta-xt-prod-extra;subdir=repo \
    file://meta-xt-prod-domx;subdir=repo \
"

XT_QUIRK_BB_ADD_LAYER_append = " \
    meta-xt-prod-extra \
    meta-xt-prod-domx \
"
################################################################################
# Generic ARMv8
################################################################################
SRC_URI += " \
    repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=prod_devel/domf.xml;scmdata=keep \
"

XT_BB_LAYERS_FILE = "meta-xt-prod-extra/doc/bblayers.conf.domf-image-minimal"
XT_BB_LOCAL_CONF_FILE = "meta-xt-prod-extra/doc/local.conf.domf-image-minimal"

configure_versions() {
    local local_conf="${S}/build/conf/local.conf"

    cd ${S}

    # HACK: force ipk instead of rpm b/c it makes troubles to PVR UM build otherwise
    base_update_conf_value ${local_conf} PACKAGE_CLASSES "package_ipk"

    # FIXME: normally bitbake fails with error if there are bbappends w/o recipes
    # which is the case for agl-demo-platform's recipe-platform while building
    # agl-image-weston: due to AGL's Yocto configuration recipe-platform is only
    # added to bblayers if building agl-demo-platform, thus making bitbake to
    # fail if this recipe is absent. Workaround this by allowing bbappends without
    # corresponding recipies.
    base_update_conf_value ${local_conf} BB_DANGLINGAPPENDS_WARNONLY "yes"

    # hvc0 is not a serial console, so is not processes properly by a modern
    # start_getty script which is installed for sysvinit based systems.
    # Instead a distro feature xen should be enabled in a configuration, so a
    # direct call to getty with hvc0 is installed into inittab by meta-viltualization.
    # Though systemd properly processes hvc0 advertised as serial console, and is not
    # provided with console by distro-feature xen.
    # So keep following line aligned with an init manager set for the system.
    base_update_conf_value ${local_conf} SERIAL_CONSOLES = "115200;hvc0"

    # set default timezone to Las Vegas
    base_update_conf_value ${local_conf} DEFAULT_TIMEZONE "US/Pacific"
}

python do_configure_append() {
    bb.build.exec_func("configure_versions", d)
}

