require inc/xt_shared_env.inc

PVRKM_URL = "git://git@gitpct.epam.com/epmd-aepr/pvr_km_vgpu_img.git"
BRANCH = "1.9/4991288-4.9"
SRCREV = "${AUTOREV}"

EXTRA_OEMAKE += "PVRSRV_VZ_NUM_OSID=${XT_PVR_NUM_OSID}"

# Build GFX kernel module without suffix
KERNEL_MODULE_PACKAGE_SUFFIX = ""

# Auto load pvrsrvkm
KERNEL_MODULE_AUTOLOAD_append = " pvrsrvkm"

FILES_${PN} = " \
    /lib/modules/${KERNEL_VERSION}/extra/pvrsrvkm.ko \
    ${sysconfdir}/modules-load.d \
"

do_install_append() {
    install -d ${DEPLOY_DIR_IMAGE}/xt-rcar
    cp -rf ${D}/* ${DEPLOY_DIR_IMAGE}/xt-rcar
}
