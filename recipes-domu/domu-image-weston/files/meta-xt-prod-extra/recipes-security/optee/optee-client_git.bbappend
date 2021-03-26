PV = "3.9.0+git${SRCPV}"
SRCREV = "e9e55969d76ddefcb5b398e592353e5c7f5df198"

COMPATIBLE_MACHINE = "salvator-x|h3ulcb|m3ulcb|m3nulcb"

EXTRA_OEMAKE  += " RPMB_EMU=1"

SYSTEMD_AUTO_ENABLE_${PN} = "disable"
