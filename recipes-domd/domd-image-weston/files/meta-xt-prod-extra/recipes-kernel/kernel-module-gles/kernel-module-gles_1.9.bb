require kernel-module-gles.inc

BRANCH = "1.9/4991288-4.9"
SRCREV = "${AUTOREV}"

KBUILD_OUTDIR_r8a7795 = "binary_r8a7795_linux_${BUILD}/target_aarch64/kbuild/"
KBUILD_OUTDIR_r8a7796 = "binary_r8a7796_linux_${BUILD}/target_aarch64/kbuild/"
KBUILD_OUTDIR_r8a77965 = "binary_r8a77965_linux_${BUILD}/target_aarch64/kbuild/"

EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"

