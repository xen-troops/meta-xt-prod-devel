require inc/xt_shared_env.inc

BRANCH = "1.11/5516664_5.1.0"
SRCREV = "${AUTOREV}"
EXCLUDED_APIS = "opencl vulkan"

EXTRA_OEMAKE += "\
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'domu', 'EXCLUDE_FENCE_SYNC_SUPPORT:=1', '', d)} \
"

DEPENDS += " \
   bison-native \
"
