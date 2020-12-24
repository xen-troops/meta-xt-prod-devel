do_build[depends] += "dom0-image-thin-initramfs:do_${BB_DEFAULT_TASK}"

XT_QEMU_DEPENDS ?= ""

python __anonymous () {
    distro_features = (d.getVar("XT_COMMON_DISTRO_FEATURES_APPEND", True) or '').split()
    if "qemu_xen" in distro_features:
        d.setVar("XT_QEMU_DEPENDS", "qemu-xilinx:do_${BB_DEFAULT_TASK} qemu-devicetrees:do_${BB_DEFAULT_TASK}")
}

do_build[depends] += "${XT_QEMU_DEPENDS}"
