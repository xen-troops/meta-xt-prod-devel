SUMMARY = "config files and scripts for a guest"
DESCRIPTION = "config files and scripts for guest which will be running for tests"

require inc/xt_shared_env.inc

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = " \
    file://bridge-nfsroot.sh \
    file://bridge.sh \
    file://doma_loop_detach.sh \
    file://doma_loop_setup.sh \
    file://android-disks.sh \
    file://displbe.service \
    file://android-disks.service \
    file://android-disks.conf \
    file://bridge-up-notification.service \
    file://display-manager.service \
    file://dm-salvator-x-m3.cfg \
    file://dm-salvator-x-h3.cfg \
    file://eth0.network \
    file://xenbr0.netdev \
    file://xenbr0.network \
    file://xenbr0-systemd-networkd.conf \
    file://port-forward-systemd-networkd.conf \
    file://sndbe.service \
"

S = "${WORKDIR}"

inherit systemd

PACKAGES += " \
    ${PN}-bridge-config \
    ${PN}-displbe-service \
    ${PN}-android-disks-service \
    ${PN}-bridge-up-notification-service \
"

FILES_${PN}-bridge-config = " \
    ${sysconfdir}/systemd/network/eth0.network \
    ${sysconfdir}/systemd/network/xenbr0.netdev \
    ${sysconfdir}/systemd/network/xenbr0.network \
    ${sysconfdir}/systemd/system/systemd-networkd.service.d/xenbr0-systemd-networkd.conf \
    ${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf \
"

SYSTEMD_PACKAGES = " \
    ${PN}-displbe-service \
    ${PN}-android-disks-service \
    ${PN}-bridge-up-notification-service \
"

SYSTEMD_SERVICE_${PN}-displbe-service = " displbe.service"

SYSTEMD_SERVICE_${PN}-android-disks-service = " android-disks.service"

SYSTEMD_SERVICE_${PN}-bridge-up-notification-service = " bridge-up-notification.service"

FILES_${PN}-android-disks-service = " \
    ${systemd_system_unitdir}/android-disks.service \
    ${sysconfdir}/tmpfiles.d/android-disks.conf \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}/android-disks.sh \
"

FILES_${PN}-displbe-service = " \
    ${systemd_system_unitdir}/displbe.service \
"

FILES_${PN}-bridge-up-notification-service = " \
    ${systemd_system_unitdir}/bridge-up-notification.service \
"
RDEPENDS_${PN}-bridge-config = " \
    ethtool \
"

DM_CONFIG_salvator-x-m3-xt = "dm-salvator-x-m3.cfg"
DM_CONFIG_salvator-x-h3-xt = "dm-salvator-x-h3.cfg"

do_install() {
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}
    install -m 0744 ${WORKDIR}/*.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}

    # N.B. display-manager must be installed as a user service which
    # is not supported by systemd.bbclass at the moment, so
    # do all dirty work by hands
    rm ${D}${systemd_system_unitdir}/display-manager.service
    install -d ${D}${systemd_user_unitdir}
    install -m 0644 ${WORKDIR}/display-manager.service ${D}${systemd_user_unitdir}
    install -d ${D}${sysconfdir}/systemd/user/default.target.wants
    ln -sf ${systemd_user_unitdir}/display-manager.service ${D}${sysconfdir}/systemd/user/default.target.wants

    install -d ${D}${sysconfdir}/tmpfiles.d
    install -m 0644 ${WORKDIR}/android-disks.conf ${D}${sysconfdir}/tmpfiles.d/android-disks.conf

    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/*.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/*.netdev ${D}${sysconfdir}/systemd/network

    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d
    install -m 0644 ${WORKDIR}/xenbr0-systemd-networkd.conf ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d
    install -m 0644 ${WORKDIR}/port-forward-systemd-networkd.conf ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d

    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}
    install -m 0744 ${WORKDIR}/${DM_CONFIG} ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}/dm.cfg

    install -d ${D}${systemd_user_unitdir}
    install -m 0644 ${WORKDIR}/sndbe.service ${D}${systemd_user_unitdir}
    rm -f ${D}${systemd_system_unitdir}/sndbe.service

    install -d ${D}${sysconfdir}/systemd/user/default.target.wants
    ln -sf ${systemd_user_unitdir}/sndbe.service ${D}${sysconfdir}/systemd/user/default.target.wants

}

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}/*.sh \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_CFG}/*.cfg \
    ${systemd_user_unitdir}/display-manager.service \
    ${systemd_user_unitdir}/sndbe.service \
    ${base_prefix}${sysconfdir}/systemd/user/default.target.wants \
"

