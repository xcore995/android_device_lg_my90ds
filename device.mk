# Copyright (C) 2013 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEVICE_PACKAGE_OVERLAYS := \
    device/lge/my90ds/overlay
		
# GPS
PRODUCT_COPY_FILES += \
     device/lge/my90ds/rootdir/system/etc/agps_profiles_conf2.xml:system/etc/agps_profiles_conf2.xml

PRODUCT_PACKAGES += \
    gps.mt6582

# Audio	
PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/system/etc/media_profiles.xml:system/etc/media_profiles.xml \
    device/lge/my90ds/rootdir/system/etc/media_codecs.xml:system/etc/media_codecs.xml \
    device/lge/my90ds/rootdir/system/etc/audio_policy.conf:system/etc/audio_policy.conf \
    device/lge/my90ds/rootdir/system/etc/media_codecs_mediatek_audio.xml:system/etc/media_codecs_mediatek_audio.xml \
    device/lge/my90ds/rootdir/system/etc/media_codecs_mediatek_video.xml:system/etc/media_codecs_mediatek_video.xml \
    device/lge/my90ds/rootdir/system/etc/mtk_omx_core.cfg:system/etc/mtk_omx_core.cfg \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:system/etc/media_codecs_google_video_le.xml

# Thermal
PRODUCT_COPY_FILES += \
     device/lge/my90ds/rootdir/system/etc/thermal/thermal.conf:system/etc/.tp/thermal.conf \
     device/lge/my90ds/rootdir/system/etc/thermal/.ht120.mtc:system/etc/.tp/.ht120.mtc \
     device/lge/my90ds/rootdir/system/etc/thermal/thermal.off.conf:system/etc/.tp/thermal.off.conf

# Keylayout
PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/system/usr/keylayout/mtk-kpd.kl:system/usr/keylayout/mtk-kpd.kl

# Hostapd
PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/system/etc/hostapd/hostapd_default.conf:system/etc/hostapd/hostapd_default.conf \
    device/lge/my90ds/rootdir/system/etc/hostapd/hostapd.accept:system/etc/hostapd/hostapd.accept \
    device/lge/my90ds/rootdir/system/etc/hostapd/hostapd.deny:system/etc/hostapd/hostapd.deny

# Ubuntu Overlay Files
PRODUCT_COPY_FILES += \
    device/lge/my90ds/halium/udev.rules:system/halium/lib/udev/rules.d/70-android.rules \
    device/lge/my90ds/halium/config.xml:system/halium/usr/share/powerd/device_configs/config-default.xml \
    device/lge/my90ds/halium/ofono.override:system/halium/etc/init/ofono.override \
    device/lge/my90ds/halium/android.conf:system/halium/etc/ubuntu-touch-session.d/android.conf

#wlan.sh
PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/system/etc/wlan.sh:system/etc/wlan.sh
	
PRODUCT_TAGS += dalvik.gc.type-precise

# RAMDISK
PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/root/init.magna_common.rc:root/init.magna_common.rc \
    device/lge/my90ds/rootdir/root/fstab.magna:root/fstab.magna \
    device/lge/my90ds/rootdir/root/init.modem.rc:root/init.modem.rc \
    device/lge/my90ds/rootdir/root/ueventd.magna.rc:root/ueventd.magna.rc \
    device/lge/my90ds/rootdir/root/init.magna.usb.rc:root/init.magna.usb.rc \
    device/lge/my90ds/rootdir/root/init.zeta0y_core.rc:root/init.zeta0y_core.rc \
    device/lge/my90ds/rootdir/root/enableswap.sh:root/enableswap.sh \
    device/lge/my90ds/rootdir/root/init.magna.rc:root/init.magna.rc

PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    libaudio-resampler \
    tinymix


# Wifi
PRODUCT_PACKAGES += \
    libwpa_client \
    hostapd \
    dhcpcd.conf \
    wpa_supplicant \
    wpa_supplicant.conf
	
PRODUCT_PACKAGES += \
    librs_jni \
    com.android.future.usb.accessory

PRODUCT_PACKAGES += \
    charger \
    charger_res_images \
    libnl_2 \
    libtinyxml

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

PRODUCT_PACKAGES += \
    setup_fs \
    e2fsck

# Power
PRODUCT_PACKAGES += \
    power.default \
    power.mt6582
	
PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
	ro.crypto.state=unencrypted \
	ro.mount.fs=EXT4 \
	ro.secure=1 \
	ro.allow.mock.location=0 \
	ro.debuggable=0 \
	ro.zygote=zygote32 \
	camera.disable_zsl_mode=1 \
	ro.telephony.ril_class=SproutRIL

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-filter=speed \
    dalvik.vm.dex2oat-swap=false	
