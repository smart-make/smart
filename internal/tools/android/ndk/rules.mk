#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME), $(SCRIPT), $(APP_OPTIM), $(APP_ABI), $(APP_PLATFORM))
#$(warning $(NAME), $(SCRIPT))
#$(info smart: AndroidNDK: Build "$(NAME)" for $(TARGET_PLATFORM) using ABI "$(TARGET_ARCH_ABI)")

## Setup toolchain version, and default to 4.6..
NDK_TOOLCHAIN_VERSION := $(or $(TOOLCHAIN_VERSION),4.7,4.6)

define smart~make~target~dir
$(eval \
  ifneq ($(smart.has.$(dir $1)),yes)
    smart.has.$(dir $1) := yes
    $(dir $1): ; @mkdir -p $$@
  endif
 )
endef #smart~make~target~dir

##
## Shortcuts used for REQUIRES computation.
smart~var = $(call smart.get,$(smart~m),$(strip $1))

############################################################
##
## Also compute REQUIRES variable for LIBRARY dependencies.
## 
## The REQUIRES variable had already been calculated by "smart" base system,
## but we do this again just for LIBRARY dependencies.
##
##  TODO: do recursive for static library, non-recursive for shared library
##
smart~libs~required :=
define smart~use
$(foreach lib,$(call smart~var,LIBRARY),$(eval \
   smart~libs~required += $(TARGET_OUT)/$(lib)
   ))$(foreach smart~m,$(call smart~var,REQUIRES),$(call smart~use))
endef #smart~use
$(foreach smart~m,$(REQUIRES),$(smart~use))
$(call smart~unique,smart~libs~required)

#$(warning $(NAME): $(smart~libs~required))

## Run the glue build code..
$(foreach smart~action,rules,$(eval include $(smart.tooldir)/glue/run.mk))

smart~make~target~dir :=
