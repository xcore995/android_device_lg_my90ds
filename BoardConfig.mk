#
# Copyright 2013 The Android Open-Source Project
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
#
LOCAL_PATH := device/lge/my90ds
# Board
TARGET_BOARD_PLATFORM := mt6582
MTK_BOARD_PLATFORMS := mt6582
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
ARCH_ARM_HAVE_VFP := true
TARGET_CPU_SMP := true
TARGET_ARCH := arm
ARCH_ARM_HAVE_NEON := true
TARGET_NO_BOOTLOADER := true
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_CPU := cortex-a7
TARGET_CPU_VARIANT:= cortex-a7
TARGET_CPU_MEMCPY_OPT_DISABLE := true


# Storage allocations
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE:=2496610304
BOARD_USERDATAIMAGE_PARTITION_SIZE:=3854680064
BOARD_CACHEIMAGE_PARTITION_SIZE:=863338496

# Used for my custom partitoning
# BOARD_CACHEIMAGE_PARTITION_SIZE:= 31457280 
# BOARD_SYSTEMIMAGE_PARTITION_SIZE:= 1560281088

BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072

PRODUCT_SHIPPING_API_LEVEL := 21
# kernel stuff
#BOARD_CUSTOM_BOOTIMG_MK := device/lge/my90ds/tools/bootimg.mk xcore: No mtk-header
#TARGET_PREBUILT_KERNEL := device/lge/my90ds/kernel
MTK_PLATFORM := mt6582
TARGET_KERNEL_SOURCE := kernel/lge/my90ds
TARGET_KERNEL_CONFIG := magna_defconfig
BOARD_KERNEL_CMDLINE := bootopt=64S3,32S1,32S1 androidboot.hardware=magna androidboot.selinux=permissive 
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x04000000 --tags_offset 0x00000100
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_IMAGE_NAME := zImage

TARGET_RECOVERY_FSTAB := device/lge/my90ds/rootdir/root/recovery.fstab


# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_MTK := true
BOARD_BLUETOOTH_DOES_NOT_USE_RFKILL := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/lge/my90ds/bluetooth


# Low Memory Devices
MALLOC_SVELTE := true

TARGET_HAS_LEGACY_CAMERA_HAL1 := true
TARGET_USES_NON_TREBLE_CAMERA := true
NEEDS_LEGACY_CAMERA_HAL1_DYN_NATIVE_HANDLE := true

# BOARD_PROVIDES_RILD := true :Obsolete? 
BOARD_PROVIDES_LIBRIL := true
ENABLE_VENDOR_RIL_SERVICE := true
TARGET_SPECIFIC_HEADER_PATH := device/lge/my90ds/include

# FM
MTK_FM_SUPPORT :=true
MTK_FM_RX_SUPPORT :=true
# MTK_WLAN_SUPPORT
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_FW_PATH_PARAM := /dev/wmtWifi
WIFI_DRIVER_FW_PATH_STA:=STA
WIFI_DRIVER_FW_PATH_AP:=AP
WIFI_DRIVER_FW_PATH_P2P:=P2P
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0

# Fix scaling on older omx
TARGET_OMX_LEGACY_RESCALING := true

TARGET_HAS_NO_WLAN_STATS := true
#Mediatek flags
BOARD_HAS_MTK_HARDWARE := true
MTK_HARDWARE := true

# FRAMEWORK WITH OUT SYNC
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

#Tap 2 wake
TARGET_TAP_TO_WAKE_NODE := "/sys/devices/virtual/input/lge_touch/tap2wake"

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# Offmode Charging
#WITH_CM_CHARGER := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true
BOARD_CHARGER_ENABLE_SUSPEND := false
BACKLIGHT_PATH := "/sys/class/leds/lcd-backlight/brightness"


TARGET_SYSTEM_PROP := device/lge/my90ds/system.prop

# Dual SIM
SIM_COUNT := 2


BOARD_EGL_CFG := device/lge/my90ds/rootdir/system/etc/egl.cfg

TARGET_USERIMAGES_USE_EXT4:=true
USE_CAMERA_STUB := true


# SELinux
BOARD_SEPOLICY_DIRS += \
    device/lge/my90ds/sepolicy

# SECCOMP
BOARD_SECCOMP_POLICY += device/lge/my90ds/seccomp

DEVICE_MANIFEST_FILE := device/lge/my90ds/manifest.xml
