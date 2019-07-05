
################################################################################
# Following inc file defines XEN version and needed glue info to get it
# built with the current yocto version
################################################################################
require ../meta-xt-images-domx/recipes-extended/xen/xen-4.12-rocko.inc

SRC_URI = "git://github.com/xen-troops/xen.git;protocol=https;branch=pv_camera"
SRCREV = "e052b80f8342bc2bb5b02a819a0bf3623373bb82"
