
################################################################################
# Following inc file defines XEN version and needed glue info to get it
# built with the current yocto version
################################################################################
require ../meta-xt-images-domx/recipes-extended/xen/xen-4.14-thud.inc

SRC_URI = "git://github.com/xen-troops/xen.git;protocol=https;branch=pci_phase2"

FILES_${PN}-xl-examples += " \
    ${sysconfdir}/xen/xlexample.pvhlinux \
"

PACKAGES_append = " \
    ${PN}-xen-access \
    "
FILES_${PN}-xen-access += " \
    ${sbindir}/xen-access \
"

FILES_${PN}-misc_append = " \
    ${sysconfdir}/bash_completion.d \
"

################################################################################
# xenpcid
################################################################################
PACKAGES_append = "\
    ${PN}-pcid \
"

FILES_${PN}-pcid = "\
    ${sbindir}/xenpcid \
    ${sysconfdir}/init.d/xen-pcid \
    ${systemd_unitdir}/system/xen-pcid.service \
"

SYSTEMD_SERVICE_${PN}-pcid += " \
    xen-pcid.service \
"

RDEPENDS_${PN}-pcid = "\
    bash \
    ${PN}-libxenvchan \
"

# configure init.d scripts
INITSCRIPT_PACKAGES += "${PN}-pcid"
INITSCRIPT_NAME_${PN}-pcid = "xen-pcid"
INITSCRIPT_PARAMS_${PN}-pcid = "defaults 81"
