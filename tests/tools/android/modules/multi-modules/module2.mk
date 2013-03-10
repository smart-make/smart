#
#    Copyright (C) 2013
#    
#    All rights reserved by Duzy Chan <code@duzy.info>.
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := module2
LOCAL_SRC_FILES := module2.c

include $(BUILD_STATIC_LIBRARY)
