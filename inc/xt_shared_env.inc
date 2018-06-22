###############################################################################
# PVR graphics
###############################################################################
# number of supported OSes for VGPU virtualization
XT_PVR_NUM_OSID="2"

###############################################################################
# locations of various artifacts within root file systems
# and shared rootfs folder
###############################################################################

# known domains
XT_DIR_REL_DOM0 = "dom0"
XT_DIR_REL_DOMD = "domd"
XT_DIR_REL_DOMA = "doma"
XT_DIR_REL_DOMF = "domf"
XT_DIR_REL_DOMR = "domr"
XT_DIR_REL_DOMU = "domu"

# these are the folders within domain's root filesystem where all
# installed artifacts live
XT_DIR_ABS_ROOTFS = "/xt"

XT_DIR_ABS_ROOTFS_DOM0 = "${XT_DIR_ABS_ROOTFS}/${XT_DIR_REL_DOM0}/"
XT_DIR_ABS_ROOTFS_DOMD = "${XT_DIR_ABS_ROOTFS}/${XT_DIR_REL_DOMD}/"
XT_DIR_ABS_ROOTFS_DOMA = "${XT_DIR_ABS_ROOTFS}/${XT_DIR_REL_DOMA}/"
XT_DIR_ABS_ROOTFS_DOMF = "${XT_DIR_ABS_ROOTFS}/${XT_DIR_REL_DOMF}/"
XT_DIR_ABS_ROOTFS_DOMR = "${XT_DIR_ABS_ROOTFS}/${XT_DIR_REL_DOMR}/"
XT_DIR_ABS_ROOTFS_DOMU = "${XT_DIR_ABS_ROOTFS}/${XT_DIR_REL_DOMU}/"

# these are folder names to be used accross domains to install
# various types of artifacts
XT_DIR_ABS_ROOTFS_SCRIPTS = "${XT_DIR_ABS_ROOTFS}/scripts"
XT_DIR_ABS_ROOTFS_CFG = "${XT_DIR_ABS_ROOTFS}/cfg"
XT_DIR_ABS_ROOTFS_DOM_CFG = "${XT_DIR_ABS_ROOTFS}/dom.cfg"

# these are the folders within ${XT_SHARED_ROOTFS_DIR}
# directory used to exchange boot artifacts between domains
# being built, e.g. kernel image, dtb etc.
XT_DIR_ABS_SHARED_BOOT_DOM0 = "${XT_SHARED_ROOTFS_DIR}/${XT_DIR_REL_DOM0}/"
XT_DIR_ABS_SHARED_BOOT_DOMD = "${XT_SHARED_ROOTFS_DIR}/${XT_DIR_REL_DOMD}/"
XT_DIR_ABS_SHARED_BOOT_DOMA = "${XT_SHARED_ROOTFS_DIR}/${XT_DIR_REL_DOMA}/"
XT_DIR_ABS_SHARED_BOOT_DOMF = "${XT_SHARED_ROOTFS_DIR}/${XT_DIR_REL_DOMF}/"
XT_DIR_ABS_SHARED_BOOT_DOMR = "${XT_SHARED_ROOTFS_DIR}/${XT_DIR_REL_DOMR}/"
XT_DIR_ABS_SHARED_BOOT_DOMU = "${XT_SHARED_ROOTFS_DIR}/${XT_DIR_REL_DOMU}/"

