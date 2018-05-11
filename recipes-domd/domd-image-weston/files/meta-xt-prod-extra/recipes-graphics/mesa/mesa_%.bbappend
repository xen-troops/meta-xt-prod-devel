# We need this header file to build gles-user-module.
# Previously it was provided by meta-renesas-rcar-gen3 layer for Qt environment.
# Recipe location: meta-renesas-rcar-gen3/meta-rcar-gen3/recipes-graphics/mesa/mesa-wayland.inc
# Since we do not use Qt the header was removed by mesa recipe,
# so we have to install it manually.
do_install_append () {
    install -Dm 644 ${S}/include/EGL/eglmesaext.h ${D}/${includedir}/EGL/eglmesaext.h
}
