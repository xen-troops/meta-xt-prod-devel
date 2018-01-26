SRCREV = "${AUTOREV}"
DESCRIPTION = "AGL surface switcher"
SECTION = "extras"
LICENSE = "GPLv2"
PR = "r0"

PN = "aglsurfaceswitcher"
PV = "0.1"

SRC_URI = "git://github.com/xen-troops/agl_surface_switcher.git;protocol=https;branch=master"

LIC_FILES_CHKSUM = "file://LICENSE;md5=a23a74b3f4caf9616230789d94217acb"

S = "${WORKDIR}/git"

EXTRA_OECMAKE = "-DWITH_WGT=ON -DCMAKE_BUILD_TYPE=Release"

DEPENDS = "libxenbe wayland-ivi-extension dbus-cpp git-native"

inherit pkgconfig cmake aglwgt
