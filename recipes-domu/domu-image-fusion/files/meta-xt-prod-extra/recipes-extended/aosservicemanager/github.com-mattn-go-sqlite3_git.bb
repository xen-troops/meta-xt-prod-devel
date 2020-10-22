DESCRIPTION = "sqlite3 driver for go using database/sql"

GO_IMPORT = "github.com/mattn/go-sqlite3"

inherit go

SRC_URI = "git://${GO_IMPORT};protocol=https;branch=master;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"
SRCREV = "92f580b350d88e068bfbe223ea51f64044c0f280"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=2b7590a6661bc1940f50329c495898c6"
PTEST_ENABLED = ""

FILES_${PN} += "${GOBIN_FINAL}/*"

do_compile[noexec] = "1"
