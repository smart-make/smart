#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

$(info smart: Android NDK: Build for $(TARGET_PLATFORM) using ABI "$(TARGET_ARCH_ABI)")

$(warning $(NAME), $(TARGET_ABI), $(TARGET_TOOLCHAIN))

ifdef SOURCES
  include $(smart.tooldir)/sources.mk
endif #SOURCES

# ./default-build-commands.mk:65:define cmd-build-shared-library
# ./default-build-commands.mk:76:define cmd-build-executable
# ./default-build-commands.mk:87:define cmd-build-static-library

ifdef LIBRARY
  include $(smart.tooldir)/library.mk
  ifdef LIBRARY
    module-$(SM.MK): $(LIBRARY)
    modules: module-$(SM.MK)
  endif #LIBRARY
endif #LIBRARY

ifdef PROGRAM
  include $(smart.tooldir)/program.mk
  ifdef PROGRAM
    module-$(SM.MK): $(PROGRAM)
    modules: module-$(SM.MK)
  endif #PROGRAM
endif #PROGRAM
