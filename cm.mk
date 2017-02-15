# Full base
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Needed stuff
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Call device specific makefile
$(call inherit-product, device/lg/magna/cm_magna.mk)

LOCAL_PATH := device/lg/magna

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_FINGERPRINT=6.0.1/MRA58K/1619509518de2:user/release-keys PRIVATE_BUILD_DESC="my90ds_global_com-user 6.0 MRA58K 1619509518de2 release-keys"

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_DEVICE="magna"

# IO Scheduler
PRODUCT_PROPERTY_OVERRIDES += \
    sys.io.scheduler=bfq    
       
PRODUCT_NAME := cm_magna
PRODUCT_DEVICE := magna
PRODUCT_BRAND := LG
PRODUCT_MANUFACTURER := LG
PRODUCT_MODEL := h502f

# Correct bootanimation size for the screen
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

# set locales & aapt config.
PRODUCT_AAPT_CONFIG := normal xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# Inherit some common CM stuff.

CM_BUILD := magna

ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=0
ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0

$(call inherit-product, vendor/cm/config/common_full_phone.mk)
