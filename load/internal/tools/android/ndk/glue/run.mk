#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifndef smart~action
  $(error smart: internal error)
endif

## Shortcuts for getting NDK module variables
smart~ndk~get = $(__ndk_modules.$(smart~m).$(strip $1))
smart~ndk~get~export = $(call module-get-export,$(smart~m),$(strip $1))

##
## References: (where BUILD_SYSTEM = $(NDK_ROOT)/build/core)
##      0.  $(BUILD_SYSTEM)/main.mk
##      0.1 $(BUILD_SYSTEM)/setup-imports.mk
##      0.2 $(BUILD_SYSTEM)/build-all.mk (foreach app)
##	    1. $(BUILD_SYSTEM)/setup-app.mk
##	    2. $(BUILD_SYSTEM)/setup-abi.mk
##	    3. $(BUILD_SYSTEM)/setup-toolchain.mk
##	    4. $(BUILD_SYSTEM)/build-binary.mk
##

#$(warning $(NAME): $(smart~action), $(notdir $(SCRIPT)))

# Which platform/abi/toolchain are we going to use?
TARGET_PLATFORM := $(strip $(or $(APP_PLATFORM),\
    android-$(NDK_MAX_PLATFORM_LEVEL)))
TARGET_ARCH_ABI :=
TARGET_TOOLCHAIN :=

## Ensure we're having APP_OPTIM for all modules!
ifndef APP_OPTIM
  $(error APP_OPTIM is undefined)
endif

$(foreach abi,$(or $(APP_ABI),armeabi),\
    $(eval TARGET_ARCH_ABI := $(abi))\
    $(eval include $(smart.tooldir)/glue/abi.mk)\
    $(eval include $(smart.tooldir)/glue/toolchain.mk)\
    $(eval include $(smart.tooldir)/glue/compute_environment.mk)\
    $(eval include $(smart.tooldir)/glue/$(smart~action).mk))
