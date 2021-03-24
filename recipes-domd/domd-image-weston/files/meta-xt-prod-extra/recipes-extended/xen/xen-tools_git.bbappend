################################################################################
# Following inc file defines XEN version for the product and its SRC_URI
################################################################################
require xen-version.inc

RDEPENDS_${PN} += "${PN}-devd"

FLASK_POLICY_FILE = "xenpolicy-${XEN_REL}*"
FILES_${PN}-flask = " \
    /boot/${FLASK_POLICY_FILE} \
"

do_deploy_append_rcar () {
    if [ -f ${D}/boot/${FLASK_POLICY_FILE} ]; then
        ln -sfr ${DEPLOYDIR}/${FLASK_POLICY_FILE} ${DEPLOYDIR}/xenpolicy
    fi
}
