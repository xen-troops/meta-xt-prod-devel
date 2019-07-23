SUMMARY = "DomD Xen components"

LICENSE = "MIT"

inherit packagegroup

RDEPENDS_packagegroup-xt-core-xen = "\
    xen-base \
    xen-flask \
    xen-xenstat \
    xen-devd \
"
