LICENSE = "CLOSED"

do_populate_lic[noexec] = "1"
do_compile[noexec] = "1"
do_install[depends] += "kernel-module-gles:do_install"
do_install[depends] += "gles-module-egl-headers:do_install"
do_install[depends] += "gles-user-module:do_install"

do_install () {
    if [ -d ${DEPLOY_DIR_IMAGE}/xt-rcar ]; then
        cd ${DEPLOY_DIR_IMAGE}
        date --rfc-3339=seconds > version.txt
        tar -czf rcar-proprietary-graphic-${MACHINE}-domu.tar.gz xt-rcar version.txt
        rm version.txt
        rm -rf xt-rcar
    fi
}

