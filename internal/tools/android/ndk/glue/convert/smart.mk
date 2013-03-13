#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

$(info smart: convert "$(call smart~get,MODULE)" into smart)

APP_ABI      := $(smart~app~abi)
APP_PLATFORM := $(smart~app~platform)

TOOL	 := android/ndk
NAME     := $(call smart~get,MODULE)
SRCDIR   := $(call smart~get,PATH)
SCRIPT   := $(call smart~get,MAKEFILE)
#ifeq ($(SCRIPT),$(smart.scripts.$(NAME)))
  SCRIPT := $(SCRIPT)-$(NAME)
#endif
SOURCES  := $(call smart~get,SRC_FILES)
OBJECTS  := $(call smart~get,OBJECTS)
INCLUDES := $(call smart~get,C_INCLUDES)
CFLAGS   := $(call smart~get,CFLAGS)
CXXFLAGS := $(call smart~get,CXXFLAGS)
CPPFLAGS := $(call smart~get,CPPFLAGS)
LDFLAGS  := $(call smart~get,LDFLAGS)
LDLIBS   := $(call smart~get,LDLIBS)

#ifeq ($(NAME),gnustl_static)
#$(warning $(NAME): $(SOURCES))
#endif

## Set target library/program
smart~set~target~STATIC_LIBRARY = LIBRARY := $(call smart~get,MODULE).a
smart~set~target~SHARED_LIBRARY = LIBRARY := $(call smart~get,MODULE).so
smart~set~target~EXECUTABLE = PROGRAM := $(call smart~get,MODULE)
$(eval $(smart~set~target~$(call smart~get,MODULE_CLASS)))

#$(warning $(NAME): $(SCRIPT), $(lastword $(MAKEFILE_LIST)))

## Pretends that we're loading from the Android.mk script
MAKEFILE_LIST += $(SCRIPT)

## Use those modules
USE_MODULES := $(strip \
  $(call smart~get,STATIC_LIBRARIES) \
  $(call smart~get,SHARED_LIBRARIES) \
  )

ifneq ($(call smart~get,WHOLE_STATIC_LIBRARIES),)
  $(warning TODO: WHOLE_STATIC_LIBRARIES)
endif

#$(warning $(NAME): $(USE_MODULES) ($(APP_ABI)))

EXPORT.CFLAGS   := $(call smart~get~export,CFLAGS)
EXPORT.CXXFLAGS := $(call smart~get~export,CXXFLAGS)
EXPORT.CPPFLAGS := $(call smart~get~export,CPPFLAGS)
EXPORT.LDFLAGS  := $(call smart~get~export,LDFLAGS)
EXPORT.LDLIBS   := $(call smart~get~export,LDLIBS)
EXPORT.INCLUDES := $(call smart~get~export,C_INCLUDES)
