DESCRIPTION = "Go client for AMQP 0.9.1."

GO_IMPORT = "github.com/streadway/amqp"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;branch=master;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "e6b33f460591b0acb2f13b04ef9cf493720ffe17"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=29358571796140f6172846eac9be80d2"
PTEST_ENABLED = ""

FILES_${PN} += "${GOBIN_FINAL}/*"

do_compile[noexec] = "1"
