FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI = "git://github.com/GENIVI/${BPN}.git;protocol=http"
SRCREV = "2.2.0_weston_5_compartible"

SRC_URI_IVI_ID_AGENT = " \
   file://0001-Added-ivi-id-agent-to-CMake.patch \
   file://0002-ivi-id-agent-added-ivi-id-agent.patch \
   file://0003-ivi-controller-load-id-agent-module.patch \
"

SRC_URI_append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'ivi-shell', SRC_URI_IVI_ID_AGENT, '', d)} \
"