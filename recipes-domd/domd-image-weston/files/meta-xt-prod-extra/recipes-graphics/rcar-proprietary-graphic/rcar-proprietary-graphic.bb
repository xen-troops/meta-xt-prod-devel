DESCRIPTION = "PowerVR GPU user and kernel modules"
LICENSE = "CLOSED"

PN = "rcar-proprietary-graphic"
PV = "1.9"
PR = "r0"

COMPATIBLE_MACHINE = "(r8a7795|r8a7796|r8a77965)"
PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}/xt-rcar"
GLES = "gsx"

SRC_URI_r8a7795 = "file://rcar-proprietary-graphic-salvator-x-h3-xt-domu.tar.gz"
SRC_URI_r8a7796 = "file://rcar-proprietary-graphic-salvator-x-m3-xt-domu.tar.gz"
SRC_URI_r8a77965 = "file://rcar-proprietary-graphic-salvator-x-m3n-xt-domu.tar.gz"

inherit update-rc.d systemd

INITSCRIPT_NAME = "pvrinit"
INITSCRIPT_PARAMS = "start 7 5 2 . stop 62 0 1 6 ."
SYSTEMD_SERVICE_${PN} = "rc.pvr.service"
KERNEL_VERSION = "${@base_read_file('${STAGING_KERNEL_BUILDDIR}/kernel-abiversion')}"

do_populate_lic[noexec] = "1"
do_compile[noexec] = "1"
do_install[depends] += "linux-renesas:do_shared_workdir"

do_install() {
    # Install configuration files
    install -d ${D}/${sysconfdir}/init.d
    install -m 644 ${S}/${sysconfdir}/powervr.ini ${D}/${sysconfdir}
    install -m 755 ${S}/${sysconfdir}/init.d/rc.pvr ${D}/${sysconfdir}/init.d/
    install -d ${D}/${sysconfdir}/udev/rules.d
    install -m 644 ${S}/${sysconfdir}/udev/rules.d/72-pvr-seat.rules ${D}/${sysconfdir}/udev/rules.d/

    # Install header files
    install -d ${D}/${includedir}/EGL
    install -m 644 ${S}/${includedir}/EGL/*.h ${D}/${includedir}/EGL/
    install -d ${D}/${includedir}/GLES2
    install -m 644 ${S}/${includedir}/GLES2/*.h ${D}/${includedir}/GLES2/
    install -d ${D}/${includedir}/GLES3
    install -m 644 ${S}/${includedir}/GLES3/*.h ${D}/${includedir}/GLES3/
    install -d ${D}/${includedir}/KHR
    install -m 644 ${S}/${includedir}/KHR/khrplatform.h ${D}/${includedir}/KHR/khrplatform.h

    # Install pre-builded binaries
    install -d ${D}/${libdir}
    install -m 755 ${S}/${libdir}/*.so ${D}/${libdir}/
    install -d ${D}/${exec_prefix}/local/bin
    install -m 755 ${S}/${exec_prefix}/local/bin/dlcsrv_REL ${D}/${exec_prefix}/local/bin/dlcsrv_REL
    install -d ${D}/lib/firmware
    install -m 644 ${S}/lib/firmware/* ${D}/lib/firmware/

    # Install pkgconfig
    install -d ${D}/${libdir}/pkgconfig
    install -m 644 ${S}/${libdir}/pkgconfig/*.pc ${D}/${libdir}/pkgconfig/

    # Create symbolic link
    cd ${D}/${libdir}
    ln -s libEGL.so libEGL.so.1
    ln -s libGLESv2.so libGLESv2.so.2

    if [ "${USE_GLES_WAYLAND}" = "1" ]; then
        # Set the "WindowSystem" parameter for wayland
        if [ "${GLES}" = "gsx" ]; then
            sed -i -e "s/WindowSystem=libpvrDRM_WSEGL.so/WindowSystem=libpvrWAYLAND_WSEGL.so/g" \
                ${D}/${sysconfdir}/powervr.ini
        fi
    fi

    # Install systemd service
    if [ ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)} ]; then
        install -d ${D}/${systemd_system_unitdir}/
        install -m 644 ${S}/${systemd_system_unitdir}/rc.pvr.service ${D}/${systemd_system_unitdir}/
        install -d ${D}/${exec_prefix}/bin
        install -m 755 ${S}/${sysconfdir}/init.d/rc.pvr ${D}/${exec_prefix}/bin/pvrinit
    fi

    # Install kernel module gles
    install -d ${D}/${sysconfdir}/modprobe.d
    install -d ${D}/${sysconfdir}/modules-load.d
    install -d ${D}/lib/modules/${KERNEL_VERSION}/extra
    install -m 644 ${S}/lib/modules/${KERNEL_VERSION}/extra/pvrsrvkm.ko ${D}/lib/modules/${KERNEL_VERSION}/extra
}

PACKAGES = "\
    ${PN} \
"

FILES_${PN} = " \
    ${sysconfdir}/* \
    ${libdir}/* \
    /lib/modules/${KERNEL_VERSION}/extra/* \
    /lib/firmware/rgx.fw* \
    /usr/local/bin/* \
    ${exec_prefix}/bin/* \
    ${includedir}/* \
    ${libdir}/pkgconfig/* \
"

PROVIDES = "virtual/libgles2 virtual/egl kernel-module-gles gles-user-module"
RPROVIDES_${PN} += " \
    kernel-module-pvrsrvkm \
    kernel-module-dc-linuxfb \
    gles-user-module \
    ${GLES}-user-module \
    libgles2-mesa \
    libgles2-mesa-dev \
    libgles2 \
    libgles2-dev \
"

RDEPENDS_${PN} = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'libgbm wayland-kms', '', d)} \
"

INSANE_SKIP_${PN} = "ldflags build-deps file-rdeps"
INSANE_SKIP_${PN}-dev = "ldflags build-deps file-rdeps"
INSANE_SKIP_${PN} += "arch"
INSANE_SKIP_${PN}-dev += "arch"
INSANE_SKIP_${PN}-dbg = "arch"

# Skip debug strip of do_populate_sysroot()
INHIBIT_SYSROOT_STRIP = "1"

# Skip debug split and strip of do_package()
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"
