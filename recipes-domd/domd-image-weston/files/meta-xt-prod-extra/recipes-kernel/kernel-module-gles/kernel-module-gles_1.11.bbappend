require inc/xt_shared_env.inc

PVRKM_URL = "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
BRANCH = "1.11/5516664_5.1.0"
SRCREV = "${AUTOREV}"

EXTRA_OEMAKE += "\
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'domu', 'EXCLUDE_FENCE_SYNC_SUPPORT:=1', '', d)} \
"
