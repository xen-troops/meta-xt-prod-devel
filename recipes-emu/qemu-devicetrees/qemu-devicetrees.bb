# Copyright (C) 2020 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

DESCRIPTION = "Xilinx QEMU device trees used for ARM PCI passthrough development"
LICENSE = "GPLv2"

inherit native

require inc/xt_shared_env.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PR = "r0"

S = "${WORKDIR}/git"

SRCREV = "${AUTOREV}"

# Fetch recursively
SRC_URI = " \
    git://github.com/xen-troops/qemu-devicetrees.git;protocol=https;branch=xilinx-pcie-no-fw \
    file://0001-PCI-passthrough-Remove-single-master-ID-limitation.patch \
"
PROVIDES = "${PN}"

EMU_DEPLOY_DIR = "${XT_EMU_DEPLOY_DIR}/${PN}"

do_configure() {
}

do_compile() {
    cd ${S}
    unset CC CFLAGS CXXFLAGS LDFLAGS
    make ${PARALLEL_MAKE}
}

do_install() {
    install -d ${EMU_DEPLOY_DIR}

    rm -rf ${EMU_DEPLOY_DIR}/${PN}/* || true
    cp -rf ${S}/LATEST/ ${EMU_DEPLOY_DIR}
}
