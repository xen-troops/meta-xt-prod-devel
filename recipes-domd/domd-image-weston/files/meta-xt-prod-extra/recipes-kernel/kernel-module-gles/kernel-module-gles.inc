require inc/xt_shared_env.inc

DESCRIPTION = "Kernel module of PowerVR GPU"
LICENSE = "GPLv2 & MIT"
LIC_FILES_CHKSUM = " \
    file://GPL-COPYING;md5=60422928ba677faaa13d6ab5f5baaa1e \
    file://MIT-COPYING;md5=8c2810fa6bfdc5ae5c15a0c1ade34054 \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit module
PN = "kernel-module-gles"
PR = "r1"
COMPATIBLE_MACHINE = "(r8a7795|r8a7796|r8a77965)"
PACKAGE_ARCH = "${MACHINE_ARCH}"

PVRKM_URL ?= "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
SRC_URI_r8a7795-es2 = "${PVRKM_URL};protocol=ssh;branch=${BRANCH}"
SRC_URI_r8a7795-es3 = "${PVRKM_URL};protocol=ssh;branch=${BRANCH}"
SRC_URI_r8a7796 = "${PVRKM_URL};protocol=ssh;branch=${BRANCH}"
SRC_URI_r8a77965 = "${PVRKM_URL};protocol=ssh;branch=${BRANCH}"

S = "${WORKDIR}/git"
B = "${KBUILD_DIR}"
BUILD = "release"

KBUILD_DIR_r8a7795-es2 = "${S}/build/linux/r8a7795_es2_linux"
KBUILD_DIR_r8a7795-es3 = "${S}/build/linux/r8a7795_linux"
KBUILD_DIR_r8a7796 = "${S}/build/linux/r8a7796_linux"
KBUILD_DIR_r8a77965 = "${S}/build/linux/r8a77965_linux"

EXTRA_OEMAKE = "KERNELDIR=${STAGING_KERNEL_BUILDDIR}"
EXTRA_OEMAKE += "CROSS_COMPILE=${CROSS_COMPILE}"

module_do_compile() {
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
    cd ${KBUILD_DIR}
    oe_runmake
}

module_do_install() {
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
    install -d ${D}/lib/modules/${KERNEL_VERSION}
    cd ${KBUILD_DIR}
    oe_runmake DISCIMAGE="${D}" install
}

# Ship the module symbol file to kerenel build dir
SYSROOT_PREPROCESS_FUNCS = "module_sysroot_symbol"

module_sysroot_symbol() {
    install -m 644 ${S}/${KBUILD_OUTDIR}/Module.symvers ${STAGING_KERNEL_BUILDDIR}/GLES.symvers
}

# Clean up the module symbol file
CLEANFUNCS = "module_clean_symbol"

module_clean_symbol() {
    rm -f ${STAGING_KERNEL_BUILDDIR}/GLES.symvers
}

RPROVIDES_${PN} += "kernel-module-pvrsrvkm kernel-module-dc-linuxfb"
