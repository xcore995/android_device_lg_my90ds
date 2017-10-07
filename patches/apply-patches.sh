#!/bin/bash
cd ../../../..
cd system/core
patch -p1 < ../../device/lg/my90ds/patches/0001-Remove-CAP_SYS_NICE-from-surfaceflinger.patch
patch -p1 < ../../device/lg/my90ds/patches/0020-healthd_batteryVoltage.patch
cd ../..
cd system/netd
patch -p1 < ../../device/lg/my90ds/patches/netd.patch
cd ../..

