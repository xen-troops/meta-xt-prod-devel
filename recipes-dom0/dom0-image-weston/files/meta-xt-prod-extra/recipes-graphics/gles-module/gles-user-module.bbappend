PVRUM_URL = "git://git@git.epam.com/epmd-aepr/pvr_um_vgpu_img.git"
BRANCH = "master"
SRCREV = "${AUTOREV}"

PVRUM_BUILD_DIR_r8a7795 = "r8a7795_linux"
PVRUM_BUILD_DIR_r8a7796 = "r8a7796_linux"

SRC_URI_r8a7795 = "${PVRUM_URL};protocol=ssh;branch=${BRANCH}"
SRC_URI_r8a7796 = "${PVRUM_URL};protocol=ssh;branch=${BRANCH}"

S = "${WORKDIR}/git"
PVRUM_DISCIMAGE = "${D}"
BUILD = "release"

