FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../inc:"

do_configure[depends] += "domd-image-weston:do_domd_install_machine_overrides"
do_compile[depends] += "domd-image-weston:do_${BB_DEFAULT_TASK}"

XT_GUESTS_BUILD ?= "doma"
XT_GUESTS_INSTALL ?= "doma"

python __anonymous () {
    machine = d.getVar('MACHINE', True)
    not_supported_machines = ["salvator-x-m3", "salvator-xs-h3", "h3ulcb", "m3ulcb", "salvator-x-h3"]
    if machine in not_supported_machines:
        warning = 'The machine {} is not supported.'.format(machine) 
        bb.warn(warning)
        bb.fatal("Use prod-devel-unsafe of prod-devel to support.")

    guests = d.getVar('XT_GUESTS_BUILD', True).split()
    if "doma" in guests :
        d.appendVarFlag("do_compile", "depends", " domu-image-android:do_${BB_DEFAULT_TASK} ")
    if "domf" in guests :
        d.appendVarFlag("do_compile", "depends", " domu-image-fusion:do_${BB_DEFAULT_TASK} ")
    if "domr" in guests :
        d.appendVarFlag("do_compile", "depends", " domu-image-litmusrt:do_${BB_DEFAULT_TASK} ")
    if "domu" in guests :
        d.appendVarFlag("do_compile", "depends", " domu-image-weston:do_${BB_DEFAULT_TASK} ")
}

################################################################################
# Generic ARMv8
################################################################################
SRC_URI = "repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=prod_devel/dom0.xml;scmdata=keep"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# these will be populated into the inner build system on do_unpack_xt_extras
# N.B. xt_shared_env.inc MUST be listed AFTER meta-xt-prod-extra
XT_QUIRK_UNPACK_SRC_URI += "\
    file://meta-xt-prod-extra;subdir=repo \
    file://xt_shared_env.inc;subdir=repo/meta-xt-prod-extra/inc \
    file://xen-version.inc;subdir=repo/meta-xt-prod-extra/recipes-extended/xen \
"

# these layers will be added to bblayers.conf on do_configure
XT_QUIRK_BB_ADD_LAYER += "meta-xt-prod-extra"

XT_BB_LAYERS_FILE = "meta-xt-prod-extra/doc/bblayers.conf.dom0-image-minimal-initramfs"
XT_BB_LOCAL_CONF_FILE = "meta-xt-prod-extra/doc/local.conf.dom0-image-minimal-initramfs"

XT_BB_IMAGE_TARGET = "core-image-thin-initramfs"

add_to_local_conf() {
    local local_conf="${S}/build/conf/local.conf"

    cd ${S}

    # hvc0 is not a serial console, so is not processes properly by a modern
    # start_getty script which is installed for sysvinit based systems.
    # Instead a distro feature xen should be enabled in a configuration, so a
    # direct call to getty with hvc0 is installed into inittab by meta-viltualization.
    base_update_conf_value ${local_conf} SERIAL_CONSOLE ""

    base_update_conf_value ${local_conf} PREFERRED_VERSION_xen "4.14.0+git\%"

    base_update_conf_value ${local_conf} XT_GUESTS_INSTALL "${XT_GUESTS_INSTALL}"
}

python do_configure_append() {
    bb.build.exec_func("add_to_local_conf", d)
}

do_install_append () {
    local LAYERDIR=${TOPDIR}/../meta-xt-prod-devel
    local TARGET="generic-armv8-xt"
    find ${LAYERDIR}/doc -iname "uirfs.sh" -exec cp -f {} ${DEPLOY_DIR}/dom0-image-thin-initramfs/images/${TARGET} \; || true
}

