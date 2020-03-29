cd frameworks/av
git reset --hard && git clean -f -d
patch -p1 < ../../device/lge/my90ds/patches/xcore/frameworks_av.patch
cd ../..
cd system/core
git reset --hard && git clean -f -d
patch -p1 < ../../device/lge/my90ds/patches/xcore/libcutils.patch
cd ../..

add_lunch_combo lineage_my90ds-userdebug
add_lunch_combo lineage_my90ds-eng
