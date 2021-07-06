DESCRIPTION = "Go client for AMQP 0.9.1."

GO_IMPORT = "github.com/streadway/amqp"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "f2399026b73c57c99648e1e5f8f0cacf9282001f"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=29358571796140f6172846eac9be80d2"
PTEST_ENABLED = ""

FILES_${PN} += "${GOBIN_FINAL}/*"

do_compile[noexec] = "1"
