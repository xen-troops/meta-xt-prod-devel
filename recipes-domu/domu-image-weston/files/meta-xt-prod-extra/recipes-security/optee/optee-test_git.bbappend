PV = "3.9.0+git${SRCPV}"
SRCREV = "f461e1d47fcc82eaa67508a3d796c11b7d26656e"

COMPATIBLE_MACHINE = "salvator-x|h3ulcb|m3ulcb|m3nulcb"

DEPENDS_append = " python3-pycryptodome-native \
                python3-pycryptodomex-native \
                python3-pyelftools-native \ 
                optee-os \
                optee-client" 

OPTEE_ARCH_aarch64 = "arm64"

TA_DEV_KIT_DIR = "${STAGING_INCDIR}/optee/export-user_ta_${OPTEE_ARCH}/"

do_compile(){
    oe_runmake xtest
    oe_runmake ta
}
