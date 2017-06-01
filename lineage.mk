# Boot animation
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

PRODUCT_LOCALES := en_US ru_RU

# Inherit some common CM stuff.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
# Call device specific makefile
$(call inherit-product, device/lg/my90ds/device.mk)


$(call inherit-product, vendor/cm/config/common_full_phone.mk)
## Device identifier. This must come after all inclusions
PRODUCT_NAME := lineage_my90ds
PRODUCT_BRAND := lge
PRODUCT_MODEL := LG-H502
PRODUCT_MANUFACTURER := LGE
PRODUCT_DEVICE := my90ds

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=my90ds_global_com \
    BUILD_FINGERPRINT=lge/my90ds_global_com/my90ds:5.0.1/LRX21Y/150751559d830:user/release-keys \
    PRIVATE_BUILD_DESC="my90ds_global_com-user 5.0.1 LRX21Y 150751559d830 release-keys" \
    TARGET_DEVICE=my90ds
