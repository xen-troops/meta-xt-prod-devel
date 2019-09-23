SUMMARY = "Para-virtualized components"

LICENSE = "MIT"

inherit packagegroup

RDEPENDS_packagegroup-xt-core-pv = "\
    guest-addons-displbe-service \
    guest-addons-sndbe-service \
    libxenbe \
    displbe \
    sndbe \
"
