SUMMARY = "Guest domain scripts, configs etc."

LICENSE = "MIT"

inherit packagegroup

RDEPENDS_packagegroup-xt-core-guest-addons = "\
    guest-addons \ 
    guest-addons-bridge-up-notification-service \
    guest-addons-bridge-config \
    guest-addons-android-disks-service \
"
