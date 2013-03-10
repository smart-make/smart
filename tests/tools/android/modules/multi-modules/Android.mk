#
#    Copyright (C) 2013
#    
#    All rights reserved by Duzy Chan <code@duzy.info>.
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := module0
LOCAL_SRC_FILES := module0.c
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)

include $(BUILD_SHARED_LIBRARY)

$(foreach m,\
	$(LOCAL_PATH)/module1.mk\
	$(LOCAL_PATH)/module2.mk\
	$(LOCAL_PATH)/module3.mk\
 ,$(eval include $m))
