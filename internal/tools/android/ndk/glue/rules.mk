#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(info smart: Android NDK: Build "$(NAME)" for $(TARGET_PLATFORM) using ABI "$(TARGET_ARCH_ABI)")
#$(warning TODO: $(NAME): LOCAL_ARM_MODE, LOCAL_ARM_NEON)

ifdef SOURCES
  include $(smart.tooldir)/sources.mk
endif #SOURCES

# ./default-build-commands.mk:65:define cmd-build-shared-library
# ./default-build-commands.mk:76:define cmd-build-executable
# ./default-build-commands.mk:87:define cmd-build-static-library

~ = $(OUT)/libs/$(TARGET_ARCH_ABI)/
ifndef smart.has.$~
  smart.has.$~ := yes
  $~: ; @mkdir -p $@
endif

ifndef smart.has.$(OUT)/$(NAME).native
  smart.has.$(OUT)/$(NAME).native := yes
  $(OUT)/$(NAME).native: NATIVE_LIST :=
  $(OUT)/$(NAME).native:
	@rm -f $@ && touch $@
	@for n in $(NATIVE_LIST) ; do echo $$n >> $@ ; done
endif

ifdef LIBRARY
  include $(smart.tooldir)/library.mk
  ifdef smart~library
    $(OUT)/$(NAME).native: $(smart~library)
    module-$(SCRIPT): $(OUT)/$(NAME).native
    modules: module-$(SCRIPT)
  endif #smart~library
endif #LIBRARY

ifdef PROGRAM
  include $(smart.tooldir)/program.mk
  ifdef smart~program
    $(OUT)/$(NAME).native: $(smart~program)
    module-$(SCRIPT): $(OUT)/$(NAME).native
    modules: module-$(SCRIPT)
  endif #smart~program
endif #PROGRAM
