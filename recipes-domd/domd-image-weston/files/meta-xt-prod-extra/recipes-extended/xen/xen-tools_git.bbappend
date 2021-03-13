################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require xen-version.inc

RDEPENDS_${PN} += "${PN}-devd"

FLASK_POLICY_FILE = "xenpolicy-${XEN_REL}*"
FILES_${PN}-flask = " \
    /boot/${FLASK_POLICY_FILE} \
"

do_install_append() {
    echo "d /var/volatile 0755 root root - -"  >> ${D}${sysconfdir}/tmpfiles.d/xen.conf
    echo "d /var/volatile/log 0755 root root - -"  >> ${D}${sysconfdir}/tmpfiles.d/xen.conf
    echo "d /var/volatile/log/xen 0755 root root - -"  >> ${D}${sysconfdir}/tmpfiles.d/xen.conf

    # FIXME: this is to fix QA Issue with pygrub:
    # ... pygrub maximum shebang size exceeded, the maximum size is 128. [shebang-size]
    rm -f ${D}/${bindir}/pygrub
    rm -f ${D}/${libdir}/xen/bin/pygrub
}

do_deploy_append_rcar () {
    if [ -f ${D}/boot/${FLASK_POLICY_FILE} ]; then
        ln -sfr ${DEPLOYDIR}/${FLASK_POLICY_FILE} ${DEPLOYDIR}/xenpolicy
    fi
}
