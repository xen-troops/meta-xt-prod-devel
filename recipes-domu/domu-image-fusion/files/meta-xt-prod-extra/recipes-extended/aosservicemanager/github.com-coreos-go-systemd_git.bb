DESCRIPTION = "Go bindings to systemd socket activation, journal, D-Bus, and unit files."

GO_IMPORT = "github.com/coreos/go-systemd"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "${AUTOREV}"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=19cbd64715b51267a47bf3750cc6a8a5"
PTEST_ENABLED = ""

FILES_${PN} += "${GOBIN_FINAL}/*"

RDEPENDS_${PN}-dev += "bash"

do_compile[noexec] = "1"
