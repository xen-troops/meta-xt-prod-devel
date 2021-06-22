SUMMARY = "A config file and a run script for an Android domain"
DESCRIPTION = "A config file and a run script for an Android domain"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://doma-generic-h3.cfg \
    file://doma-generic-h3-4x2g.cfg \
    file://doma-generic-m3-2x4g.cfg \
    file://doma-vdevices.cfg \
    file://guest_doma \
    file://domx-pvcamera.cfg \
"

S = "${WORKDIR}"

DOMA_CONFIG                        = "doma-generic-h3.cfg"
DOMA_CONFIG_salvator-x-h3-4x2g-xt  = "doma-generic-h3-4x2g.cfg"
DOMA_CONFIG_salvator-xs-h3-4x2g-xt = "doma-generic-h3-4x2g.cfg"
DOMA_CONFIG_h3ulcb-4x2g-xt         = "doma-generic-h3-4x2g.cfg"
DOMA_CONFIG_h3ulcb-4x2g-ab-xt      = "doma-generic-h3-4x2g.cfg"
DOMA_CONFIG_h3ulcb-4x2g-kf-xt      = "doma-generic-h3-4x2g.cfg"
DOMA_CONFIG_salvator-xs-m3-2x4g-xt = "doma-generic-m3-2x4g.cfg"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg \
"

inherit update-rc.d

FILES_${PN}-run += " \
    ${sysconfdir}/init.d/guest_doma \
"

PACKAGES += " \
    ${PN}-run \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run"

INITSCRIPT_NAME_${PN}-run = "guest_doma"
INITSCRIPT_PARAMS_${PN}-run = "defaults 87"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}
    install -m 0744 ${WORKDIR}/${DOMA_CONFIG} ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg
    cat ${WORKDIR}/doma-vdevices.cfg       >> ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg

    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/guest_doma ${D}${sysconfdir}/init.d/

    if ${@bb.utils.contains('DISTRO_FEATURES', 'pvcamera', 'true', 'false', d)}; then
        cat ${WORKDIR}/domx-pvcamera.cfg >> ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg
        # Update GUEST_DEPENDENCIES by adding camerabe after sndbe
        sed -i 's/\<sndbe\>/& camerabe/' ${D}${sysconfdir}/init.d/guest_doma
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES', 'virtio', 'true', 'false', d)}; then
        sed -i 's/doma, xvda/doma, xvda, virtio/' \
        ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg

        # Update boot_devices by changing 51712 to 2000000
        sed -i 's/androidboot.boot_devices=51712/androidboot.boot_devices=2000000.virtio/' \
        ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/doma.cfg

        # Update GUEST_DEPENDENCIES by adding virtio-disk after sndbe
        sed -i 's/\<sndbe\>/& virtio-disk/' ${D}${sysconfdir}/init.d/guest_doma
    fi
}
