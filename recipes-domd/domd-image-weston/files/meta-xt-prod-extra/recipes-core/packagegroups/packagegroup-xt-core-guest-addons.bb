SUMMARY = "Guest domain scripts, configs etc."

LICENSE = "MIT"

inherit packagegroup

RDEPENDS_packagegroup-xt-core-guest-addons = "\
    guest-addons \ 
    guest-addons-bridge-up-notification-service \
    guest-addons-bridge-config \
    ${@bb.utils.contains('XT_GUESTS_INSTALL', 'doma', 'guest-addons-android-disks-service', '', d)} \
"
