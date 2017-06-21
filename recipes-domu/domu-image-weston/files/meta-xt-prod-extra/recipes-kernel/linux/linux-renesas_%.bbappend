FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RENESAS_BSP_URL = "git://github.com/xen-troops/linux.git"

BRANCH = "vgpu-dev"
SRCREV = "${AUTOREV}"
SRC_URI_append = " \
    file://defconfig \
"
require linux-kernel.inc

