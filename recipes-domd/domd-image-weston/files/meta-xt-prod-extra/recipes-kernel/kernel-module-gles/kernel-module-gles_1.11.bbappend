FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
require inc/xt_shared_env.inc

PVRKM_URL = "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
BRANCH = "1.11/5516664"
SRCREV = "${AUTOREV}"

# W/A fix build errors with GCC 8.1
SRC_URI_append = " file://0001-Silenced-Wcast-function-type-Wsizeof-pointer-div-and.patch"

SRC_URI_append_h3ulcb-4x2g-kf-xt = " file://0001-Update-xen_back-DMA-tweaks.patch"
