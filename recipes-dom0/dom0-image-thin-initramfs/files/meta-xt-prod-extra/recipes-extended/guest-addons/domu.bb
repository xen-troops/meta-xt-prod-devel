SUMMARY = "config files and scripts for a Weston guest"
DESCRIPTION = "config files and scripts for guest which will be running for tests"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
    file://domu-m3ulcb.cfg \
    file://domu-generic-h3.cfg \
    file://domu-salvator-x-m3.cfg \
    file://domu-salvator-xs-m3n.cfg \
    file://domu-generic-h3-4x2g.cfg \
    file://domu-generic-m3-2x4g.cfg \
    file://domu-vdevices.cfg \
    file://guest_domu \
    file://domx-pvcamera.cfg \
"

S = "${WORKDIR}"

DOMU_CONFIG_salvator-x-m3-xt       = "domu-salvator-x-m3.cfg"
DOMU_CONFIG_salvator-x-h3-xt       = "domu-generic-h3.cfg"
DOMU_CONFIG_salvator-xs-m3n-xt     = "domu-salvator-xs-m3n.cfg"
DOMU_CONFIG_salvator-x-h3-4x2g-xt  = "domu-generic-h3-4x2g.cfg"
DOMU_CONFIG_salvator-xs-h3-xt      = "domu-generic-h3.cfg"
DOMU_CONFIG_salvator-xs-h3-4x2g-xt = "domu-generic-h3-4x2g.cfg"
DOMU_CONFIG_m3ulcb-xt              = "domu-m3ulcb.cfg"
DOMU_CONFIG_h3ulcb-xt              = "domu-generic-h3.cfg"
DOMU_CONFIG_h3ulcb-4x2g-xt         = "domu-generic-h3-4x2g.cfg"
DOMU_CONFIG_h3ulcb-4x2g-ab-xt      = "domu-generic-h3-4x2g.cfg"
DOMU_CONFIG_h3ulcb-4x2g-kf-xt      = "domu-generic-h3-4x2g.cfg"
DOMU_CONFIG_salvator-xs-m3-2x4g-xt = "domu-generic-m3-2x4g.cfg"

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg \
"

inherit update-rc.d

FILES_${PN}-run += " \
    ${sysconfdir}/init.d/guest_domu \
"

PACKAGES += " \
    ${PN}-run \
"

# configure init.d scripts
INITSCRIPT_PACKAGES = "${PN}-run"

INITSCRIPT_NAME_${PN}-run = "guest_domu"
INITSCRIPT_PARAMS_${PN}-run = "defaults 87"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}
    install -m 0744 ${WORKDIR}/${DOMU_CONFIG} ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg
    cat ${WORKDIR}/domu-vdevices.cfg >> ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg

    install -d ${D}${sysconfdir}/init.d
    install -m 0744 ${WORKDIR}/guest_domu ${D}${sysconfdir}/init.d/

    if ${@bb.utils.contains('DISTRO_FEATURES', 'pvcamera', 'true', 'false', d)}; then
        cat ${WORKDIR}/domx-pvcamera.cfg >> ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg
        # Update GUEST_DEPENDENCIES by adding camerabe after sndbe
        sed -i 's/\<sndbe\>/& camerabe/' ${D}${sysconfdir}/init.d/guest_domu
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES', 'virtio', 'true', 'false', d)}; then
        sed -i 's/3, xvda1/3, xvda1, virtio/' \
        ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg

        # Update root by changing xvda1 to vda
        sed -i 's/root=\/dev\/xvda1/root=\/dev\/vda/' \
        ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_DOM_CFG}/domu.cfg

        # Update GUEST_DEPENDENCIES by adding virtio-disk after sndbe
        sed -i 's/\<sndbe\>/& virtio-disk/' ${D}${sysconfdir}/init.d/guest_domu
    fi
}
