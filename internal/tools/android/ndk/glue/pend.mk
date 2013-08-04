#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifeq ($(or $(TARGET_PLATFORM),$(TARGET_ARCH_ABI),$(TARGET_TOOLCHAIN),$(TARGET_ARCH_ABI),$(TARGET_ARCH)),)
  $(error smart: internal error)
endif

##
## Process Android NDK IMPORTS.
## 
ifdef IMPORTS
  ifneq ($(findstring ../,$(MODULE_PATH)),)
    $(error MODULE_PATH contains "..": "$(MODULE_PATH)")
  endif
  $(foreach 1,$(MODULE_PATH),$(call import-add-path,$1))
  $(foreach 1,$(IMPORTS),$(call import-module,$1))
endif

##
## Convert Android NDK modules into smart build system. The USE_MODULES
## variable is used by Android NDK build system in a Android.mk.
##     *) See $(modules-get-list) for all modules
##
ifdef USE_MODULES
  $(foreach smart~convert,$(smart.tooldir)/glue/convert,\
      $(foreach smart~m,$(USE_MODULES),\
          $(eval include $(smart.tooldir)/glue/convert.mk)))
endif

# $(warning $(NAME): $(SCRIPT))
