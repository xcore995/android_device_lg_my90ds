# Boot animation
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

PRODUCT_LOCALES := en_US ru_RU

# Inherit some common CM stuff.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
# Call device specific makefile
$(call inherit-product, device/lg/my90ds/device.mk)


# Inherit some common AOSP-OMS stuff.
$(call inherit-product, vendor/aosp/common.mk)

PRODUCT_PACKAGES += \
    SnapdragonCamera

## Device identifier. This must come after all inclusions
PRODUCT_NAME := aosp_my90ds
PRODUCT_BRAND := lge
PRODUCT_MODEL := LG-H502
PRODUCT_MANUFACTURER := LGE
PRODUCT_DEVICE := my90ds

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=my90ds_global_com \
    TARGET_DEVICE=my90ds
