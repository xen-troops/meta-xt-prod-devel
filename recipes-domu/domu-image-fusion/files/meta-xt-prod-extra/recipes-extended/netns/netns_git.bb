DESCRIPTION = "github.com/genuinetools/netns/"

GO_IMPORT = "github.com/genuinetools/netns/"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "${AUTOREV}"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=48ef0979a2bcc3fae14ff30b8a7f5dbf"

CGO_ENABLED = "1"
FILES_${PN} += "${GOBIN_FINAL}/*"
