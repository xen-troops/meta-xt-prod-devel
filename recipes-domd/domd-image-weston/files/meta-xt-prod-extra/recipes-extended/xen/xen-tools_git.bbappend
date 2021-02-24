################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require xen-version.inc

RDEPENDS_${PN} = "${PN}-devd"
