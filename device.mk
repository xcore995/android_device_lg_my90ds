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
	
# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:system/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml


PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.camera.manual_sensor.xml:system/etc/permissions/android.hardware.camera.manual_sensor.xml

	
# GPS
PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/system/etc/agps_profiles_conf2.xml:system/etc/agps_profiles_conf2.xml

PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    gps.mt6582

# GPS force mode
PRODUCT_PROPERTY_OVERRIDES += \
    persist.force.gps.mode=gnss

# Vibrator HAL
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.light@2.0-impl

# Seccomp policy
PRODUCT_COPY_FILES += \
    device/lge/my90ds/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# HIDL Manifest
PRODUCT_COPY_FILES += \
    device/lge/my90ds/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

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
	
PRODUCT_TAGS += dalvik.gc.type-precise

# RAMDISK
PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/root/init.magna_common.rc:root/init.magna_common.rc \
    device/lge/my90ds/rootdir/root/init.protect.rc:root/init.protect.rc \
    device/lge/my90ds/rootdir/root/fstab.magna:root/fstab.magna \
    device/lge/my90ds/rootdir/root/init.modem.rc:root/init.modem.rc \
    device/lge/my90ds/rootdir/root/factory_init.rc:root/factory_init.rc \
    device/lge/my90ds/rootdir/root/ueventd.magna.rc:root/ueventd.magna.rc \
    device/lge/my90ds/rootdir/root/init.magna.usb.rc:root/init.magna.usb.rc \
    device/lge/my90ds/rootdir/root/init.zeta0y_core.rc:root/init.zeta0y_core.rc \
    device/lge/my90ds/rootdir/root/init.magna.rc:root/init.magna.rc

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    libaudio-resampler \
    tinymix
	
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl 

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl
	
# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.renderscript@1.0-impl \
    libgralloc_extra \
    libui_ext \
    libgui_ext
# Camera HAL
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl-legacy \
    libcam.client

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

PRODUCT_PACKAGES += \
    libmagna
    
# USB	
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Wifi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wificond \
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
    
# Thermal HAL
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    sensors.magna

PRODUCT_COPY_FILES += \
    device/lge/my90ds/rootdir/system/etc/_hals.conf:system/vendor/etc/sensors/_hals.conf

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl \
    power.mt6582
	
PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
	ro.crypto.state=unencrypted \
	ro.mount.fs=EXT4 \
	ro.secure=1 \
	ro.allow.mock.location=0 \
	ro.debuggable=1 \
	ro.zygote=zygote32 \
	camera.disable_zsl_mode=1 \
	dalvik.vm.dex2oat-Xms=64m \
	dalvik.vm.dex2oat-Xmx=512m \
	dalvik.vm.image-dex2oat-Xms=64m \
	dalvik.vm.image-dex2oat-Xmx=64m \
	ro.dalvik.vm.native.bridge=0 \
        camera.disable_zsl_mode=1

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-filter=speed \
    dalvik.vm.dex2oat-swap=false	
