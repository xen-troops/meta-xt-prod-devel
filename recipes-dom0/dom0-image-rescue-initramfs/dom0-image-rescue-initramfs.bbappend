FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../inc:"

do_fetch[depends] += "domd-agl-demo-platform:do_${BB_DEFAULT_TASK}"

SRC_URI = " \
    repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=prod_ces2018/dom0.xml;scmdata=keep \
"

###############################################################################
# extra layers and files to be put after Yocto's do_unpack into inner builder
###############################################################################
# these will be populated into the inner build system on do_unpack_xt_extras
# N.B. xt_shared_env.inc MUST be listed AFTER meta-xt-prod-extra
XT_QUIRK_UNPACK_SRC_URI += " \
    file://meta-xt-prod-extra;subdir=repo \
    file://xt_shared_env.inc;subdir=repo/meta-xt-prod-extra/inc \
"

# these layers will be added to bblayers.conf on do_configure
XT_QUIRK_BB_ADD_LAYER += "meta-xt-prod-extra"

XT_BB_LAYERS_FILE = "meta-xt-prod-extra/doc/bblayers.conf.dom0-image-rescue-initramfs"
XT_BB_LOCAL_CONF_FILE = "meta-xt-prod-extra/doc/local.conf.dom0-image-rescue-initramfs"

XT_BB_IMAGE_TARGET = "core-image-thin-initramfs"

add_to_local_conf() {
    local local_conf="${S}/build/conf/local.conf"

    cd ${S}

    # FIXME: although we do not install Xen we still run as Xen
    # domain, so serial console, used for login shell must be the
    # virtual one, e.g. hvc0
    # FIXME: meta-virtualization layer will also update this
    # when DISTRO_FEATURES has "xen" in it. But in our case it is not set,
    # so still set up the console on our own
    base_update_conf_value ${local_conf} SERIAL_CONSOLE "115200 hvc0"
}

python do_configure_append() {
    bb.build.exec_func("add_to_local_conf", d)
}

