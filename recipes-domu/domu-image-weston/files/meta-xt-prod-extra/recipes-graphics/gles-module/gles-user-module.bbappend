FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PVRUM_URL = "git://git@git.epam.com/epmd-aepr/pvr_um_vgpu_img.git"
BRANCH = "vgpu-img"
SRCREV = "${AUTOREV}"

PVRUM_BUILD_DIR_r8a7795 = "vzguest_linux"
PVRUM_BUILD_DIR_r8a7796 = "vzguest_linux"

SRC_URI_r8a7795 = "${PVRUM_URL};protocol=ssh;branch=${BRANCH}"
SRC_URI_r8a7796 = "${PVRUM_URL};protocol=ssh;branch=${BRANCH}"

S = "${WORKDIR}/git"
PVRUM_DISCIMAGE = "${D}"
BUILD = "release"

EXTRA_OEMAKE += "SUPPORT_PVRSRV_GPUVIRT=1 PVRSRV_GPUVIRT_NUM_OSID=${PVR_NUM_OSID}"
EXTRA_OEMAKE += "PVRSRV_GPUVIRT_GUESTDRV=1"

