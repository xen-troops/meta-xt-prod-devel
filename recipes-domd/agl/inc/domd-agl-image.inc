FILESEXTRAPATHS_prepend := "${THISDIR}/../files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../../inc:"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# these will be populated into the inner build system on do_unpack_xt_extras
# N.B. xt_shared_env.inc MUST be listed AFTER meta-xt-prod-extra
XT_QUIRK_UNPACK_SRC_URI += "\
    file://meta-xt-prod-extra;subdir=repo \
    file://xt_shared_env.inc;subdir=repo/meta-xt-prod-extra/inc \
"

# add new xt-distro machines into AGL
XT_QUIRK_UNPACK_SRC_URI += "file://meta-agl;subdir=repo"
XT_QUIRK_UNPACK_SRC_URI += "file://meta-agl-bsp;subdir=repo/meta-agl"

# these layers will be added to bblayers.conf on do_configure
XT_QUIRK_BB_ADD_LAYER += "meta-xt-prod-extra"

# Override revision of AGL auxiliary layers
# N.B. the revision to use must be aligned with Poky's version of AGL to be built with
BRANCH = "morty"

# Renesas R-Car
################################################################################
SRCREV_agl-repo = "${AUTOREV}"
SRCREV_img-proprietary = "ef24526e95ba339c39ef966f2a7e364b563946d2"

SRC_URI_rcar = "repo://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo;protocol=https;branch=dab;manifest=dab_4.0.2.xml;scmdata=keep;name=agl-repo \
    git://git@gitpct.epam.com/epmd-aepr/img-proprietary;protocol=ssh;branch=master;name=img-proprietary;destsuffix=repo/proprietary \
    file://0001-Do-not-try-to-use-XDG-environment-while-setting-up.patch \
"

configure_versions_rcar() {
    local local_conf="${S}/build/conf/local.conf"

    cd ${S}
    base_update_conf_value ${local_conf} PREFERRED_VERSION_xen "4.9+git\%"
    base_update_conf_value ${local_conf} PREFERRED_VERSION_u-boot_rcar "v2015.04\%"
    base_update_conf_value ${local_conf} PREFERRED_VERSION_gles-user-module "1.9"
    base_update_conf_value ${local_conf} PREFERRED_VERSION_gles-kernel-module "1.9"

    # HACK: force ipk instead of rpm b/c it makes troubles to PVR UM build otherwise
    base_update_conf_value ${local_conf} PACKAGE_CLASSES "package_ipk"

    # FIXME: normally bitbake fails with error if there are bbappends w/o recipes
    # which is the case for agl-demo-platform's recipe-platform while building
    # agl-image-weston: due to AGL's Yocto configuration recipe-platform is only
    # added to bblayers if building agl-demo-platform, thus making bitbake to
    # fail if this recipe is absent. Workaround this by allowing bbappends without
    # corresponding recipies.
    base_update_conf_value ${local_conf} BB_DANGLINGAPPENDS_WARNONLY "yes"

    # override console specified by default by the meta-rcar-gen3
    # to be hypervisor's one
    base_update_conf_value ${local_conf} SERIAL_CONSOLE "115200 hvc0"

    # set default timezone to Las Vegas
    base_update_conf_value ${local_conf} DEFAULT_TIMEZONE "US/Pacific"
}

python do_configure_append_rcar() {
    bb.build.exec_func("configure_versions_rcar", d)
}

