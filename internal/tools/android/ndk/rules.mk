#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME), $(APP_ABI), $(APP_PLATFORM))

## Setup toolchain version, and default to 4.6..
NDK_TOOLCHAIN_VERSION := $(or $(TOOLCHAIN_VERSION),4.7,4.6)

## Build it as a new app..
$(foreach smart~app,rules,$(eval include $(smart.tooldir)/glue/app.mk))
