FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

BRANCH = "v4.14.75-ltsi/rcar-3.9.6-xt0.1"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "4.14.75"

SRC_URI = " \
    git://github.com/xen-troops/linux.git;branch=${BRANCH} \
    file://defconfig \
  "

SRC_URI_append = " \
    file://0001-xen-privcmd-add-IOCTL_PRIVCMD_MMAP_RESOURCE.patch \
"

do_deploy_append () {
    find ${D}/boot -iname "vmlinux*" -exec tar -cJvf ${STAGING_KERNEL_BUILDDIR}/vmlinux.tar.xz {} \;
}
