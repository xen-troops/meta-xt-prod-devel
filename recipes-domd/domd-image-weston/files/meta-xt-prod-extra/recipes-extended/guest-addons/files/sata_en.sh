#!/bin/sh

echo "Bringing up sata (make sure that SW12-pin7 is off)"

i2cset -y -f 4 0x20 0x02 0x00
i2cset -y -f 4 0x20 0x03 0x7f
i2cset -y -f 4 0x20 0x01 0x7f

modprobe sata_rcar
