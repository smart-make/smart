#
#    Copyright (C) 2012-08-04.
#    
#    All rights reserved by Duzy Chan <code@duzy.info>.
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := foo_app
LOCAL_SRC_FILES := foo_app_glue.c
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)
LOCAL_EXPORT_LDLIBS := -llog -landroid

include $(BUILD_STATIC_LIBRARY)
