require inc/xt_shared_env.inc

do_deploy_append() {
    mkdir -p ${XT_DIR_ABS_SHARED_BOOT_DOMR}
    rm -f ${XT_DIR_ABS_SHARED_BOOT_DOMR}/Image*
    cp -f --no-dereference --preserve=links ${DEPLOYDIR}/Image* ${XT_DIR_ABS_SHARED_BOOT_DOMR}/
}
