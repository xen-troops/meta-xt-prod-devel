require inc/xt_shared_env.inc

EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"

PVRKM_URL = "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"

BRANCH = "1.9/4991288-4.9"
SRCREV = "${AUTOREV}"
