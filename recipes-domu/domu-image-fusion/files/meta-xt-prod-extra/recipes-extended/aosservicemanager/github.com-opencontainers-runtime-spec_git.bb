DESCRIPTION = "OCI Runtime Specification http://www.opencontainers.org"

GO_IMPORT = "github.com/opencontainers/runtime-spec"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;branch=master;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "e6143ca7d51d11b9ab01cf4bc39e73e744241a1b"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=b355a61a394a504dacde901c958f662c"
PTEST_ENABLED = ""

FILES_${PN} += "${GOBIN_FINAL}/*"

do_compile[noexec] = "1"
