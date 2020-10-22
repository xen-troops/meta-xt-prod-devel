DESCRIPTION = "Structured, pluggable logging for Go."

GO_IMPORT = "github.com/sirupsen/logrus"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;branch=master;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "d131c24e23baaa812461202af6d7cfa388e2d292"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=8dadfef729c08ec4e631c4f6fc5d43a0"
PTEST_ENABLED = ""

FILES_${PN} += "${GOBIN_FINAL}/*"

do_compile[noexec] = "1"
