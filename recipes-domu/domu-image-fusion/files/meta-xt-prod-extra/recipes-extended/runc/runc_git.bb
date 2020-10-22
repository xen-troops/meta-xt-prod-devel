DESCRIPTION = "github.com/opencontainers/runc/"

GO_IMPORT = "github.com/opencontainers/runc/"

inherit go

export CGO_ENABLED="1"

SRC_URI = "git://${GO_IMPORT};protocol=https;branch=master;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "4633f7bef8cb098c655a0a85742d0acdd334c66f"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=435b266b3899aa8a959f17d41c56def8"

RDEPENDS_${PN}-dev += "bash"
CGO_ENABLED = "1"
FILES_${PN} += "${GOBIN_FINAL}/*"
