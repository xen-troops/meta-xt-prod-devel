echo 1 > /sys/bus/pci/devices/0000\:02\:02.0/remove
echo 1 > /sys/bus/pci/devices/0000\:02\:03.0/remove
echo -n 12@02:02.0\;12@02:03.0 > /sys/bus/pci/resource_alignment
echo 1 > /sys/bus/pci/rescan
