################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require inc/xen-version.inc

DEPENDS_remove = "systemd"

PACKAGECONFIG[xsm] = ""

do_install_append() {
    # FIXME: this is to fix run-time issues
    # "libxl__lock_domain_userdata: Domain 0:cannot open lockfile /var/lib/xen/"

    install -d ${D}${localstatedir}/lib/xen

    # FIXME: this is to fix QA Issue with pygrub:
    # ... pygrub maximum shebang size exceeded, the maximum size is 128. [shebang-size]
    rm -f ${D}/${bindir}/pygrub
    rm -f ${D}/${libdir}/xen/bin/pygrub
}

FILES_${PN}-xencommons += " \
    ${localstatedir}/lib/xen \
"
