require inc/xt_shared_env.inc

share_artifacts () {
    mkdir -p ${XT_DIR_ABS_SHARED_BOOT_DOMR}
    rm -f ${XT_DIR_ABS_SHARED_BOOT_DOMR}/*.cpio.gz
    cp -f --no-dereference --preserve=links ${IMGDEPLOYDIR}/*.cpio.gz ${XT_DIR_ABS_SHARED_BOOT_DOMR}
}

IMAGE_POSTPROCESS_COMMAND += " share_artifacts; "
