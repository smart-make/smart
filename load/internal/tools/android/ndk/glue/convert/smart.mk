#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

$(info smart: convert "$(call smart~ndk~get,MODULE)" into smart)

TOOL	 := android/ndk
NAME     := $(call smart~ndk~get,MODULE)
SRCDIR   := $(call smart~ndk~get,PATH)
SCRIPT   := $(call smart~ndk~get,MAKEFILE)
#ifeq ($(SCRIPT),$(smart.scripts.$(NAME)))
  SCRIPT := $(SCRIPT)-$(NAME)
#endif
SOURCES  := $(call smart~ndk~get,SRC_FILES)
OBJECTS  := $(call smart~ndk~get,OBJECTS)
INCLUDES := $(call smart~ndk~get,C_INCLUDES)
CFLAGS   := $(call smart~ndk~get,CFLAGS)
CXXFLAGS := $(call smart~ndk~get,CXXFLAGS)
CPPFLAGS := $(call smart~ndk~get,CPPFLAGS)
LDFLAGS  := $(call smart~ndk~get,LDFLAGS)
LDLIBS   := $(call smart~ndk~get,LDLIBS)
FULLLIBS += $(call smart~ndk~get,WHOLE_STATIC_LIBRARIES)
CPP_FEATURES := $(call smart~ndk~get,CPP_FEATURES)

EXPORT.CFLAGS   := $(call smart~ndk~get~export,CFLAGS)
EXPORT.CXXFLAGS := $(call smart~ndk~get~export,CXXFLAGS)
EXPORT.CPPFLAGS := $(call smart~ndk~get~export,CPPFLAGS)
EXPORT.LDFLAGS  := $(call smart~ndk~get~export,LDFLAGS)
EXPORT.LDLIBS   := $(call smart~ndk~get~export,LDLIBS)
EXPORT.INCLUDES := $(call smart~ndk~get~export,C_INCLUDES)
EXPORT.OBJECTS  := $(call smart~ndk~get~export,OBJECTS)
EXPORT.CPP_FEATURES  := $(call smart~ndk~get~export,CPP_FEATURES)

## Set target library/program
ifneq ($(filter -l$(NAME),$(EXPORT.LDLIBS)),)
  smart~set~target~STATIC_LIBRARY = LIBRARY := lib$(NAME:lib%=%).a
  smart~set~target~SHARED_LIBRARY = LIBRARY := lib$(NAME:lib%=%).so
  smart~set~target~EXECUTABLE = PROGRAM := $(NAME)
else
  smart~set~target~STATIC_LIBRARY = LIBRARY := $(NAME).a
  smart~set~target~SHARED_LIBRARY = LIBRARY := $(NAME).so
  smart~set~target~EXECUTABLE = PROGRAM := $(NAME)
endif
$(eval $(smart~set~target~$(call smart~ndk~get,MODULE_CLASS)))

#$(warning $(NAME): $(SCRIPT), $(lastword $(MAKEFILE_LIST)))

## Pretends that we're loading from the Android.mk script
MAKEFILE_LIST += $(SCRIPT)

## Use those modules
USE_MODULES := $(strip \
  $(call smart~ndk~get,STATIC_LIBRARIES) \
  $(call smart~ndk~get,SHARED_LIBRARIES) \
  )

#$(warning $(NAME): $(USE_MODULES) ($(APP_ABI)))
