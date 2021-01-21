FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require xen-version.inc

SRC_URI_append_domu-1to1 = " \
    file://domu_1to1/0001-Set-ECAM-for-vPCI-to-true-physical-address.patch \
    file://domu_1to1/0002-Do-not-use-memory-over-4G-move-DomU-kernel-in-memory.patch \
    file://domu_1to1/0003-xen-arm-allow-to-allocate-1-128-256-512-Mb-memory-ch.patch \
"

################################################################################
# We only need Xen tools, so we can start domains
################################################################################

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

