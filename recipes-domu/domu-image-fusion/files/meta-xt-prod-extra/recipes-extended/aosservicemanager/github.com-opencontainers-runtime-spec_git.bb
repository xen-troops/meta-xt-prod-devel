DESCRIPTION = "OCI Runtime Specification http://www.opencontainers.org"

GO_IMPORT = "github.com/opencontainers/runtime-spec"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "1c3f411f041711bbeecf35ff7e93461ea6789220"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=b355a61a394a504dacde901c958f662c"
PTEST_ENABLED = ""

FILES_${PN} += "${GOBIN_FINAL}/*"

do_compile[noexec] = "1"
