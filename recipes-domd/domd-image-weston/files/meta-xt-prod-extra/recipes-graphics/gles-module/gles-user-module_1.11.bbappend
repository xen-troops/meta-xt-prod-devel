require inc/xt_shared_env.inc

BRANCH = "1.11/5516664"
SRCREV = "${AUTOREV}"
EXCLUDED_APIS = "opencl vulkan"

# Linux based guests do not require such option to be enabled in a host
EXTRA_OEMAKE += "\
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'domu', 'PVRSRV_SYNC_CHECKPOINT_CCB=0', '', d)} \
"
