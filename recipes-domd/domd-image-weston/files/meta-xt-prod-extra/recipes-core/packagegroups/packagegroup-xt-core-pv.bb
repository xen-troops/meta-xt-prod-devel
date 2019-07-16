SUMMARY = "Para-virtualized components"

LICENSE = "MIT"

inherit packagegroup

RDEPENDS_packagegroup-xt-core-pv = "\
    guest-addons-displbe-service \
    libxenbe \
    displbe \
    sndbe \
"
