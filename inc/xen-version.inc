
################################################################################
# Following inc file defines XEN version and needed glue info to get it
# built with the current yocto version
################################################################################
require ../meta-xt-images-domx/recipes-extended/xen/xen-4.14-thud.inc

SRC_URI = "git://github.com/xen-troops/xen.git;protocol=https;branch=xen-4.14rc-migration"
SRCREV = "21a187f5b0867871ec7b97f336cf383d6ddf2970"
