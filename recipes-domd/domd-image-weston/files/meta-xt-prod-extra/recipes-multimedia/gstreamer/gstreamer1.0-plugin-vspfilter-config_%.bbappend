FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

VSPFILTER_CONF_r8a7795 = "gstvspfilter-${@d.getVar('XT_CANONICAL_MACHINE_NAME', False)}_r8a7795.conf"
VSPFILTER_CONF_r8a7796 = "gstvspfilter-${@d.getVar('XT_CANONICAL_MACHINE_NAME', False)}_r8a7796.conf"
VSPFILTER_CONF_r8a77965 = "gstvspfilter-${@d.getVar('XT_CANONICAL_MACHINE_NAME', False)}_r8a77965.conf"

SRC_URI_append = " \
    file://gstvspfilter.rules \
"

FILES_${PN} += " \
    ${sysconfdir}/udev/rules.d/gstvspfilter.rules \
"

do_install_append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/gstvspfilter.rules ${D}${sysconfdir}/udev/rules.d/gstvspfilter.rules
}
