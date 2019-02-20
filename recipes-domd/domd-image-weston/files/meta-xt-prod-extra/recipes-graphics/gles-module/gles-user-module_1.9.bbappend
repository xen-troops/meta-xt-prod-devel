require inc/xt_shared_env.inc

BRANCH = "1.9/4991288"
SRCREV = "${AUTOREV}"

SRC_URI_remove = " \
    file://gcc6_pvr_um_1.9.patch \
"
