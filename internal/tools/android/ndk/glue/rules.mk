#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(info smart: Android NDK: Build "$(NAME)" for $(TARGET_PLATFORM) using ABI "$(TARGET_ARCH_ABI)")

define smart~make~target~dir
$(eval \
  ifneq ($(smart.has.$(dir $1)),yes)
    smart.has.$(dir $1) := yes
    $(dir $1): ; @mkdir -p $$@
  endif
 )
endef #smart~make~target~dir

ifdef SOURCES
  include $(smart.tooldir)/sources.mk
endif #SOURCES

# ./default-build-commands.mk:65:define cmd-build-shared-library
# ./default-build-commands.mk:76:define cmd-build-executable
# ./default-build-commands.mk:87:define cmd-build-static-library

ifndef smart.has.$(OUT)/$(NAME).native
  smart.has.$(OUT)/$(NAME).native := yes
  $(OUT)/$(NAME).native:
	@rm -f $@ && touch $@
	@for n in $(filter-out %.a,$^) ; do echo $$n >> $@ ; done
endif

ifdef LIBRARY
  include $(smart.tooldir)/library.mk
  ifdef smart~library
    module-$(SCRIPT): $(OUT)/$(NAME).native
    modules: module-$(SCRIPT)
  endif #smart~library
endif #LIBRARY

ifdef PROGRAM
  include $(smart.tooldir)/program.mk
  ifdef smart~program
    module-$(SCRIPT): $(OUT)/$(NAME).native
    modules: module-$(SCRIPT)
  endif #smart~program
endif #PROGRAM

smart~make~target~dir :=
