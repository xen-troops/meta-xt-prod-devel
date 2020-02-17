SUMMARY = "Para-virtualized components"

LICENSE = "MIT"

inherit packagegroup

RDEPENDS_packagegroup-xt-core-pv = "\
    libxenbe \
    displbe \
    sndbe \
    ${@bb.utils.contains('DISTRO_FEATURES', 'pvcamera', 'camerabe', '', d)} \
"
