FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require inc/xt_shared_env.inc

BRANCH = "1.9/4813199-ces2018"
SRCREV = "${AUTOREV}"

SRC_URI_append = " \
    file://0001-Make-compiler-target-aarch64-agl-linux-be-recognized.patch \
"
EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"

