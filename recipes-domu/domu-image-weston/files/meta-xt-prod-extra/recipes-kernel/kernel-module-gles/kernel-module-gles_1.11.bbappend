FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
require inc/xt_shared_env.inc

PVRKM_URL = "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
BRANCH = "1.11/5516664-1"
SRCREV = "175d3951046f22cde8cf1f7d83aca9da7a7baccb"

# W/A fix build errors with GCC 8.1
SRC_URI_append = " file://0001-Silenced-Wcast-function-type-Wsizeof-pointer-div-and.patch"
