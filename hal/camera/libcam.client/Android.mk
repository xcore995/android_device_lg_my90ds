# wrapper library for libcam.halsensor
#
LOCAL_PATH := $(call my-dir)
ifeq ($(USE_MTK_CAMERA_WRAPPER),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    StreamImgBuf.cpp \

LOCAL_C_INCLUDES := \
    $(TOP)/system/media/camera/include

LOCAL_SHARED_LIBRARIES := liblog libutils libcutils libdl \
			  libcam1client libcam_utils

LOCAL_MODULE := libcam.client
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)
endif
