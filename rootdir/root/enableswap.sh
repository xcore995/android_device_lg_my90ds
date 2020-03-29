#!/bin/sh
echo 536870912 > /sys/block/zram0/disksize
/system/bin/mkswap /dev/zram0
/system/bin/swapon /dev/zram0
