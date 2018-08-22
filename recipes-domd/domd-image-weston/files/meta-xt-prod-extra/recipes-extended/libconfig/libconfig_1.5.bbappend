SRC_URI = "git://github.com/hyperrealm/libconfig.git;tag=v1.5"

S = "${WORKDIR}/git"

inherit cmake autotools-brokensep pkgconfig
