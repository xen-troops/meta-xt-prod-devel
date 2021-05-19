DESCRIPTION = "Xilinx QEMU used for ARM PCI passthrough development"
LICENSE = "GPLv2"

inherit native
require inc/xt_shared_env.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PR = "r0"

S = "${WORKDIR}/git"

SRCREV = "${AUTOREV}"

RUN_SCRIPT_NAME="qemu-run-zynqmp-xilinx-xen.sh"

# Fetch recursively
SRC_URI = " \
    git://github.com/xen-troops/qemu.git;protocol=https;branch=xilinx-pcie-no-fw \
    file://${RUN_SCRIPT_NAME} \
    file://trace_events.txt \
    file://rtl8139_dual.cfg \
    file://rtl8139_single.cfg \
    file://0001-PCI-passthrough-Remove-single-master-ID-limitation.patch \
"

SRC_URI_append-dbg-rtl8139 = " \
    file://0001-Enable-RTL8139-logs.patch \
    file://0001-SMMU-Log-translations.patch \
"

PROVIDES = "${PN}"


do_configure() {
    cd ${S}
    unset CC CFLAGS CXXFLAGS LDFLAGS
    unset PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
    ./configure --target-list=aarch64-softmmu --enable-trace-backends=log
}

do_compile() {
    cd ${S}
    unset CC CFLAGS CXXFLAGS LDFLAGS
    make ${PARALLEL_MAKE}
}

do_install() {
    install -d ${XT_EMU_DEPLOY_DIR}/${PN}/aarch64-softmmu

    install -m 0744 ${S}/aarch64-softmmu/qemu-system-aarch64 ${XT_EMU_DEPLOY_DIR}/${PN}/aarch64-softmmu/

    # Write environment setup file
    install -m 0744 ${S}/../${RUN_SCRIPT_NAME} ${XT_EMU_DEPLOY_DIR}/
    install -m 0744 ${S}/../trace_events.txt ${XT_EMU_DEPLOY_DIR}/

    sed -i "s!=\"REPLACE_DEPLOY_DIR!"=\"${DEPLOY_DIR}"!g" ${XT_EMU_DEPLOY_DIR}/${RUN_SCRIPT_NAME}

    install -m 0744 ${S}/../rtl8139_dual.cfg ${XT_EMU_DEPLOY_DIR}/
    install -m 0744 ${S}/../rtl8139_single.cfg ${XT_EMU_DEPLOY_DIR}/
}
