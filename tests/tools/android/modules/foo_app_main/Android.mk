#
#    Copyright (C) 2012-08-04.
#    
#    All rights reserved by Duzy Chan <code@duzy.info>.
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := foo_app_main
LOCAL_SRC_FILES := android_main.c
LOCAL_EXPORT_STATIC_LIBRARIES := foo_app
LOCAL_STATIC_LIBRARIES := foo_app

include $(BUILD_SHARED_LIBRARY)

$(call import-module,foo_app_glue)
