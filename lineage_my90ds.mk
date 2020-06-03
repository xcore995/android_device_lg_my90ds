# Boot animation
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Call device specific makefile
$(call inherit-product, device/lge/my90ds/device.mk)

# call the proprietary setup
$(call inherit-product, vendor/lge/my90ds/my90ds-vendor.mk)

# Initial Product Shipping API Level of the Device
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_m.mk)

TARGET_BOOTANIMATION_HALF_RES := true

## Device identifier. This must come after all inclusions
PRODUCT_NAME := lineage_my90ds
PRODUCT_BRAND := lge
PRODUCT_MODEL := LG-H502
PRODUCT_MANUFACTURER := LGE
PRODUCT_DEVICE := my90ds
PRODUCT_GMS_CLIENTID_BASE := android-lge

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=my90ds_global_com \
    TARGET_DEVICE=my90ds
	
TARGET_VENDOR_PRODUCT_NAME := my90ds
TARGET_VENDOR_DEVICE_NAME := my90ds

PRODUCT_BUILD_PROP_OVERRIDES += \
BUILD_FINGERPRINT=lge/my90ds_global_com/my90ds:6.0/MRA58K/1619509518de2:user/release-keys \
PRIVATE_BUILD_DESC="my90ds_global_com-user 6.0 MRA58K 1619509518de2 release-keys"

TARGET_VENDOR := lge
