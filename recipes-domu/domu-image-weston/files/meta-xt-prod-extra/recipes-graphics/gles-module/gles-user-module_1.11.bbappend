require gles-user-module.inc

BRANCH = "1.11/5516664_5.1.0"
SRCREV = "${AUTOREV}"
EXCLUDED_APIS = "opencl vulkan"

EXTRA_OEMAKE += "EXCLUDE_FENCE_SYNC_SUPPORT:=1"

DEPENDS += " \
   bison-native \
"
