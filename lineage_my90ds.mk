$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

## Device identifier. This must come after all inclusions
PRODUCT_NAME := lineage_my90ds
PRODUCT_BRAND := lge
PRODUCT_MODEL := LG-H502
PRODUCT_MANUFACTURER := LGE
PRODUCT_DEVICE := my90ds
PRODUCT_GMS_CLIENTID_BASE := android-lge

PRODUCT_COPY_FILES += device/lge/my90ds/twrp.fstab:recovery/root/etc/twrp.fstab
