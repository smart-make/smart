#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(info smart: Android NDK: Build "$(NAME)" for $(TARGET_PLATFORM) using ABI "$(TARGET_ARCH_ABI)")
$(warning TODO: LOCAL_ARM_MODE, LOCAL_ARM_NEON)

ifdef SOURCES
  include $(smart.tooldir)/sources.mk
endif #SOURCES

# ./default-build-commands.mk:65:define cmd-build-shared-library
# ./default-build-commands.mk:76:define cmd-build-executable
# ./default-build-commands.mk:87:define cmd-build-static-library

ifdef LIBRARY
  include $(smart.tooldir)/library.mk
  ifdef smart~library
    module-$(SCRIPT): $(smart~library)
    modules: module-$(SCRIPT)
  endif #smart~library
endif #LIBRARY

ifdef PROGRAM
  include $(smart.tooldir)/program.mk
  ifdef smart~program
    module-$(SCRIPT): $(smart~program)
    modules: module-$(SCRIPT)
  endif #smart~program
endif #PROGRAM
