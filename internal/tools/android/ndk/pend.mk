#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME), $(APP_ABI), $(APP_PLATFORM), $(SCRIPT))

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
#$(warning $(NAME): $(USE_MODULES))
smart~app~abi := $(APP_ABI)
smart~app~platform := $(APP_PLATFORM)
$(foreach smart~convert,$(smart.tooldir)/glue/convert,\
    $(foreach smart~m,$(USE_MODULES),\
        $(eval include $(smart.tooldir)/glue/convert.mk)))
endif
