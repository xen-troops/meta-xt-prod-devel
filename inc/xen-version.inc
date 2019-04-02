
################################################################################
# Following inc file defines XEN version and needed glue info to get it
# built with the current yocto version
################################################################################
require ../meta-xt-images-domx/recipes-extended/xen/xen-4.12-rocko.inc

SRC_URI = "git://github.com/xen-troops/xen.git;protocol=https;branch=master"
SRCREV = "bf161fab8e10d9f84cce67fdcf8a6d8ad68e692a"
