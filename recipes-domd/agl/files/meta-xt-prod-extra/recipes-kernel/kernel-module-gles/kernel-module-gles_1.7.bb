require kernel-module-gles.inc

BRANCH = "1.7/4563938-ces2018"
SRCREV = "${AUTOREV}"

KBUILD_OUTDIR_r8a7795 = "binary_r8a7795_linux_${BUILD}/host/target_aarch64/kbuild/"
KBUILD_OUTDIR_r8a7796 = "binary_r8a7796_linux_${BUILD}/host/target_aarch64/kbuild/"

EXTRA_OEMAKE += "SUPPORT_PVRSRV_GPUVIRT=1 PVRSRV_GPUVIRT_NUM_OSID=${XT_PVR_NUM_OSID} KCFLAGS=-DGPUVIRT_HOST_NOT_1_TO_1"

