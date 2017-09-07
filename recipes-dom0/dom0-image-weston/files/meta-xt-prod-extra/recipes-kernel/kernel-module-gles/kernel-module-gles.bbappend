PVRKM_URL = "git://git@git.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
BRANCH = "vgpu-img"
SRCREV = "${AUTOREV}"

SRC_URI_r8a7795 = "${PVRKM_URL};protocol=ssh;branch=${BRANCH}"
SRC_URI_r8a7796 = "${PVRKM_URL};protocol=ssh;branch=${BRANCH}"

S = "${WORKDIR}/git"

BUILD = "release"
KBUILD_OUTDIR_r8a7795 = "binary_r8a7795_linux_${BUILD}/host/target_aarch64/kbuild/"
KBUILD_OUTDIR_r8a7796 = "binary_r8a7796_linux_${BUILD}/host/target_aarch64/kbuild/"

EXTRA_OEMAKE += "SUPPORT_PVRSRV_GPUVIRT=1 PVRSRV_GPUVIRT_NUM_OSID=${PVR_NUM_OSID}"

