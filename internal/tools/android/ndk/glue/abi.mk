#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

##
## Reference:
##     NDK: $(BUILD_SYSTEM)/setup-abi.mk
## 

TARGET_ARCH := $(strip $(NDK_ABI.$(TARGET_ARCH_ABI).arch))
TARGET_OUT = $(OUT)/libs/$(APP_OPTIM)/$(TARGET_ABI)
TARGET_OBJS = $(OUT)/objs/$(APP_OPTIM)/$(TARGET_ABI)
TARGET_GDB_SETUP = $(TARGET_OUT)/setup.gdb
