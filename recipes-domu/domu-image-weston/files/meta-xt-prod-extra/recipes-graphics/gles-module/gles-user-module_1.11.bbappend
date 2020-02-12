require gles-user-module.inc

BRANCH = "1.11/5516664"
SRCREV = "${AUTOREV}"
EXCLUDED_APIS = "opencl vulkan"

# Linux based guests do not require such option itself
EXTRA_OEMAKE += "PVRSRV_SYNC_CHECKPOINT_CCB=0"
