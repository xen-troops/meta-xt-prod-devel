FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../recipes-domx:"

do_configure[depends] += "domd-image-weston:do_domd_install_machine_overrides"

python __anonymous () {
    product_name = d.getVar('XT_PRODUCT_NAME', True)
    folder_name = product_name.replace("-", "_")
    d.setVar('XT_MANIFEST_FOLDER', folder_name)

    if product_name == "prod-devel-src": 
        if d.getVar('XT_RCAR_EVAPROPRIETARY_DIR'):
            bb.warn("Ingore XT_RCAR_EVAPROPRIETARY_DIR={} for {}".format(d.getVar('XT_RCAR_EVAPROPRIETARY_DIR'), d.getVar('XT_PRODUCT_NAME')))
            d.delVar("XT_RCAR_EVAPROPRIETARY_DIR")
}

SRC_URI = " \
    repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=${XT_MANIFEST_FOLDER}/domu.xml;scmdata=keep \
"

XT_QUIRK_PATCH_SRC_URI_rcar = "\
    file://0001-gstreamer1.0-plugins-bad-change-git-protcol-at-https.patch;patchdir=meta-renesas \
    file://0001-gstreamer1.0-plugins-good-change-git-protocol-at-htt.patch;patchdir=meta-renesas \
"

XT_QUIRK_UNPACK_SRC_URI += " \
    file://meta-xt-prod-extra;subdir=repo \
    file://meta-xt-prod-domx;subdir=repo \
"

XT_QUIRK_BB_ADD_LAYER += " \
    meta-xt-prod-extra \
    meta-xt-prod-domx \
"

XT_BB_IMAGE_TARGET = "core-image-weston"

################################################################################
# Renesas R-Car
################################################################################

XT_BB_LOCAL_CONF_FILE_rcar = "meta-xt-prod-extra/doc/local.conf.rcar-domu-image-weston"
XT_BB_LAYERS_FILE_rcar = "meta-xt-prod-extra/doc/bblayers.conf.rcar-domu-image-weston"

GLES_VERSION_rcar = "1.11"

# In order to copy proprietary "graphics" packages,
# XT_RCAR_EVAPROPRIETARY_DIR variable under [local_conf] section in
# the configuration file should point to the real packages location.
configure_versions_rcar() {
    local local_conf="${S}/build/conf/local.conf"

    cd ${S}
    if [ -z ${XT_RCAR_EVAPROPRIETARY_DIR} ];then
        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_gles-user-module "gles-user-module"
        base_update_conf_value ${local_conf} PREFERRED_VERSION_gles-user-module ${GLES_VERSION}

        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-gles "kernel-module-gles"
        base_update_conf_value ${local_conf} PREFERRED_VERSION_kernel-module-gles ${GLES_VERSION}

        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_gles-module-egl-headers "gles-module-egl-headers"
        base_update_conf_value ${local_conf} PREFERRED_VERSION_gles-module-egl-headers ${GLES_VERSION}
        base_add_conf_value ${local_conf} EXTRA_IMAGEDEPENDS "prepare-graphic-package"
    else
        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_virtual/libgles2 "rcar-proprietary-graphic"
        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_virtual/egl "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-pvrsrvkm "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-dc-linuxfb "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-gles "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_gles-user-module "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_gles-module-egl-headers "rcar-proprietary-graphic"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-images-vgpu/recipes-graphics/gles-module/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-extra/recipes-graphics/gles-module/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-vgpu/recipes-graphics/gles-module/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-vgpu/recipes-graphics/wayland/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-vgpu/recipes-kernel/kernel-module-gles/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-images-vgpu/recipes-kernel/kernel-module-gles/"
        base_add_conf_value ${local_conf} BBMASK "meta-renesas/meta-rcar-gen3/recipes-kernel/kernel-module-gles/"
        base_add_conf_value ${local_conf} BBMASK "meta-renesas/meta-rcar-gen3/recipes-graphics/gles-module/"
        xt_unpack_proprietary
    fi

    # Use base recipes for optee tools only from meta-arm layer
    base_add_conf_value ${local_conf} BBMASK "meta-renesas/meta-rcar-gen3/recipes-bsp/optee/optee-client"
    base_set_conf_value ${local_conf} PREFERRED_PROVIDER_optee-test "meta-arm"
    base_set_conf_value ${local_conf} PREFERRED_PROVIDER_optee-client "meta-arm"

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
    base_update_conf_value ${local_conf} SERIAL_CONSOLES "115200;hvc0"


    # set default timezone to Las Vegas
    base_update_conf_value ${local_conf} DEFAULT_TIMEZONE "US/Pacific"

    if [ ! -z "${XT_COMMON_DISTRO_FEATURES_APPEND}" ]; then
        base_set_conf_value ${local_conf} DISTRO_FEATURES_append " ${XT_COMMON_DISTRO_FEATURES_APPEND}"
    fi
}

python do_configure_append_rcar() {
    bb.build.exec_func("configure_versions_rcar", d)
}
