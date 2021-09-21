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
    file://android-disks.service \
    file://android-disks.conf \
    file://bridge-up-notification.service \
    file://eth0.network \
    file://xenbr0.netdev \
    file://xenbr0.network \
    file://port-forward-systemd-networkd.conf \
    file://systemd-networkd-wait-online.conf \
"

S = "${WORKDIR}"

inherit systemd

PACKAGES += " \
    ${PN}-bridge-config \
    ${PN}-android-disks-service \
    ${PN}-bridge-up-notification-service \
"

FILES_${PN}-bridge-config = " \
    ${sysconfdir}/systemd/network/eth0.network \
    ${sysconfdir}/systemd/network/xenbr0.netdev \
    ${sysconfdir}/systemd/network/xenbr0.network \
    ${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf \
    ${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d/systemd-networkd-wait-online.conf \
"

SYSTEMD_PACKAGES = " \
    ${PN}-android-disks-service \
    ${PN}-bridge-up-notification-service \
"

SYSTEMD_SERVICE_${PN}-android-disks-service = "${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'android-disks.service', '', d)}"

SYSTEMD_SERVICE_${PN}-bridge-up-notification-service = " bridge-up-notification.service"

FILES_${PN}-android-disks-service = " \
    ${systemd_system_unitdir}/android-disks.service \
    ${sysconfdir}/tmpfiles.d/android-disks.conf \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}/android-disks.sh \
"

FILES_${PN}-bridge-up-notification-service = " \
    ${systemd_system_unitdir}/bridge-up-notification.service \
"
RDEPENDS_${PN}-bridge-config = " \
    ethtool \
"

do_install() {
    # Install bridge/network artifacts
    install -d ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}
    install -m 0744 ${WORKDIR}/bridge-nfsroot.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}
    install -m 0744 ${WORKDIR}/bridge.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/bridge-up-notification.service ${D}${systemd_system_unitdir}

    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/*.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/*.netdev ${D}${sysconfdir}/systemd/network

    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d
    install -m 0644 ${WORKDIR}/port-forward-systemd-networkd.conf ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d
    if ${@bb.utils.contains('XT_GUESTS_INSTALL', 'domf', 'true', 'false', d)}; then
        echo "\n# SSH to domF" \
            >> ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf
        echo "ExecStartPost=+/usr/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2022 -j DNAT --to-destination 192.168.0.3:22" \
            >> ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf
    fi
    if ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'true', 'false', d)}; then
        echo "\n# ADB to domA" \
            >> ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf
        echo "ExecStartPost=+/usr/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 5555 -j DNAT --to-destination 192.168.0.4:5555" \
            >> ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf
    fi
    if ${@bb.utils.contains('XT_GUESTS_INSTALL', 'domu', 'true', 'false', d)}; then
        echo "\n# SSH to domU" \
            >> ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf
        echo "ExecStartPost=+/usr/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2025 -j DNAT --to-destination 192.168.0.5:22" \
            >> ${D}${sysconfdir}/systemd/system/systemd-networkd.service.d/port-forward-systemd-networkd.conf
    fi

    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d
    install -m 0644 ${WORKDIR}/systemd-networkd-wait-online.conf ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d

    if ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'true', 'false', d)}; then
        # Install android-disks artifacts
        install -d ${D}${sysconfdir}/tmpfiles.d
        install -m 0644 ${WORKDIR}/android-disks.conf ${D}${sysconfdir}/tmpfiles.d/android-disks.conf

        install -m 0744 ${WORKDIR}/doma_loop_detach.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}
        install -m 0744 ${WORKDIR}/doma_loop_setup.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}
        install -m 0744 ${WORKDIR}/android-disks.sh ${D}${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}

        install -m 0644 ${WORKDIR}/android-disks.service ${D}${systemd_system_unitdir}
    fi
}

FILES_${PN} = " \
    ${base_prefix}${XT_DIR_ABS_ROOTFS_SCRIPTS}/*.sh \
"

