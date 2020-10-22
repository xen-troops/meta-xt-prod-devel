FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "v4.14.75-ltsi/rcar-3.9.6-xt0.1"
SRCREV = "a49b495859d0d379ac4ca2068a5c42c1452df8b3"
LINUX_VERSION = "4.14.75"

SRC_URI = " \
    git://github.com/xen-troops/linux.git;branch=${BRANCH} \
    file://defconfig \
  "
do_deploy_append () {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}
