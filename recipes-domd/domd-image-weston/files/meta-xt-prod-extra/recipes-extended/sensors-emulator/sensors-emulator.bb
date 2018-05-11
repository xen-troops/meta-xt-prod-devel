SUMMARY = "sensors emulator for CES2018 demo"
DESCRIPTION = "config files and scripts for guest which will be running for tests"

require inc/xt_shared_env.inc

DIR_SENSOR_EMULATOR = "${XT_DIR_ABS_ROOTFS}/sensors-emulator"

PV = "0.1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = " \
    file://emulator.py \
    file://map.json \
    file://sensors_config.py \
    file://sensors_info_sender.py \
    file://sensors-emulator.service \
"

S = "${WORKDIR}"

RDEPENDS_${PN} = " \
    python3-json \
    python3-misc \
    python3-threading \
    python3-signal \
    python3-selectors \
    python3-datetime \
    python3-netclient \
    python3-stringold \
    python3-shell \
    python3-compression \
    python3-argparse \
    python3-textutils \
"

inherit systemd

SYSTEMD_PACKAGES = " \
    ${PN} \
"

SYSTEMD_SERVICE_${PN} = " sensors-emulator.service"

FILES_${PN} = " \
    ${systemd_system_unitdir}/sensors-emulator.service \
    ${base_prefix}${DIR_SENSOR_EMULATOR}/*.py \
    ${base_prefix}${DIR_SENSOR_EMULATOR}/*.json \
"

do_install() {
    install -d ${D}${base_prefix}${DIR_SENSOR_EMULATOR}
    install -m 0644 ${WORKDIR}/*.py ${D}${base_prefix}${DIR_SENSOR_EMULATOR}
    install -m 0644 ${WORKDIR}/*.json ${D}${base_prefix}${DIR_SENSOR_EMULATOR}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/*.service ${D}${systemd_system_unitdir}
}

