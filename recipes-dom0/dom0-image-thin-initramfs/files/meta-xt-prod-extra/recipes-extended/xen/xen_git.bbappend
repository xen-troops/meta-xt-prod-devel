FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require xen-version.inc

################################################################################
# We only need Xen tools, so we can start domains
################################################################################
SRC_URI_append = " \
    file://0001-libxl-Add-DTB-compatible-list-to-config-file.patch \
    file://0002-libxl-Add-DTB-passthrough-nodes-list.patch \
"

DEPENDS_remove = "systemd"

PACKAGECONFIG[xsm] = ""

do_install_append() {
    # FIXME: we do not want XSM, but Xen still installs it making
    # package QA Issue to raise for files installed
    rm ${D}/boot/xenpolicy-${XEN_REL}* || true

    # FIXME: this is to fix run-time issues
    # "libxl__lock_domain_userdata: Domain 0:cannot open lockfile /var/lib/xen/"

    install -d ${D}${localstatedir}/lib/xen
}

FILES_${PN}-xencommons += " \
    ${localstatedir}/lib/xen \
"

