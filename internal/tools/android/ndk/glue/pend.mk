#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifeq ($(or $(TARGET_PLATFORM),$(TARGET_ARCH_ABI),$(TARGET_TOOLCHAIN),$(TARGET_ARCH_ABI),$(TARGET_ARCH)),)
  $(error smart: internal error)
endif

## Process imports..
ifdef IMPORTS
ifneq ($(findstring ../,$(MODULE_PATH)),)
  $(error MODULE_PATH contains "..": "$(MODULE_PATH)")
endif
$(foreach 1,$(MODULE_PATH),$(call import-add-path,$1))
$(foreach 1,$(IMPORTS),$(call import-module,$1))
endif

## Convert Android NDK modules into smart build system..
##     *) See $(modules-get-list) for all modules
ifdef USE_MODULES
## Use smart~app~* to pass APP_* variables to imported modules.
smart~app~abi := $(APP_ABI)
smart~app~platform := $(APP_PLATFORM)
smart~app~stl := $(APP_STL)
#$(warning $(NAME): $(USE_MODULES))
$(foreach smart~convert,$(smart.tooldir)/glue/convert,\
    $(foreach smart~m,$(USE_MODULES),\
        $(eval include $(smart.tooldir)/glue/convert.mk)))
#smart~app~abi :=
#smart~app~platform :=
#smart~app~stl :=
endif
