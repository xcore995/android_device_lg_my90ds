cd frameworks/av
git reset --hard && git clean -f -d
patch -p1 < ../../device/lg/my90ds/patches/xcore/frameworks_av.patch
cd ../..

add_lunch_combo lineage_my90ds-userdebug
add_lunch_combo lineage_my90ds-eng
