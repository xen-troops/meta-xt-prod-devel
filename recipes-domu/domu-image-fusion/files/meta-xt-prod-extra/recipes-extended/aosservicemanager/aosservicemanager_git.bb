DESCRIPTION = "AOS Service Manager"

LICENSE = "CLOSED"

GO_IMPORT = "gitpct.epam.com/epmd-aepr/aos_servicemanager"

SRCREV = "demo_0.1"
SRC_URI = "git://git@${GO_IMPORT}.git;protocol=ssh;destsuffix=${PN}-${PV}/src/${GO_IMPORT}"

inherit go

GO_LINKSHARED = ""
PTEST_ENABLED = ""
CGO_ENABLED = "1"

DEPENDS += "\
    github.com-cavaliercoder-grab \
    github.com-coreos-go-systemd \
    github.com-godbus-dbus \
    github.com-mattn-go-sqlite3 \
    github.com-opencontainers-runtime-spec \
    github.com-sirupsen-logrus \
    github.com-streadway-amqp \
    golang-x-crypto \
"

RDEPENDS_${PN} += "\
	runc \
	netns \
	aos-addons \
	openssl \
	ca-certificates \
	python3 \
	iptables \
"

RDEPENDS_${PN}-dev += "bash"

FILES_${PN} += "${GOBIN_FINAL}/*"
