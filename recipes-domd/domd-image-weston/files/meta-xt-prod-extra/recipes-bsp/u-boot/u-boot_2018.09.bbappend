FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://0001-ARM-rcar_gen3-Add-R8A7795-8GiB-RAM-Salvator-X-board-.patch \
    file://0001-Revert-net-ravb-Fix-stop-RAVB-module-clock-before-OS.patch \
    file://0001-pci-renesas-Add-RCar-Gen3-PCIe-controller-driver.patch \
    file://0002-Enable-PCI-related-configs.patch \
    file://0003-Fix-missing-MACCTLR-register-setting-in-initializati.patch \   
"