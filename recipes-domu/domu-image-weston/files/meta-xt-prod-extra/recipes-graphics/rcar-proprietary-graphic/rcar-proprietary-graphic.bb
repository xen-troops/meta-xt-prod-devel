
require recipes-graphics/gles-module/rcar-proprietary-graphic.inc

python __anonymous () {
    if d.getVar("XT_RCAR_EVAPROPRIETARY_DIR", True):
        d.setVar("SRC_URI", "file://rcar-proprietary-graphic-${MACHINE}-domu.tar.gz")
}
