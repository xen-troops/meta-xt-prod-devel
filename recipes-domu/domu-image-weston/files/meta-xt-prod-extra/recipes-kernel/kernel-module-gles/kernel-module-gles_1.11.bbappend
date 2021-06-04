require inc/xt_shared_env.inc

PVRKM_URL = "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
BRANCH = "1.11/5516664_5.1.0"
SRCREV = "${AUTOREV}"

EXTRA_OEMAKE += "EXCLUDE_FENCE_SYNC_SUPPORT:=1"
