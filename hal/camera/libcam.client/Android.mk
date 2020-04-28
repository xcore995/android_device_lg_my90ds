# wrapper library for libcam.client
# XCORE: Based on danielhk's wrapper
# XCORE: Added RecBufManager for video recording
# XCORE: Works fine

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    StreamImgBuf.cpp \
    RecBufManager.cpp

LOCAL_C_INCLUDES := \
    $(TOP)/system/media/camera/include \
    $(TOP)/system/core/include \
    $(TOP)/frameworks/native/libs/nativebase/include \
    $(TOP)/device/lge/my90ds/hal/graphics/libgralloc_extra/include \
    $(TOP)/system/core/libion/include \
    $(TOP)/frameworks/native/libs/nativewindow/include

LOCAL_SHARED_LIBRARIES := liblog libbinder libutils libcutils libdl libcam1client libcam_utils libui libion_mtk libion libgralloc_extra

LOCAL_MODULE := libcam.client
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

