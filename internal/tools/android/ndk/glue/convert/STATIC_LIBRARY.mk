#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

$(info smart: convert "$(call smart~get,MODULE)" into smart)

TOOL	 := android/ndk
NAME     := $(call smart~get,MODULE)
SCRIPT   := $(call smart~get,MAKEFILE)
LIBRARY  := $(call smart~get,MODULE).a
SOURCES  := $(call smart~get,SRC_FILES)
INCLUDES := $(call smart~get,C_INCLUDES)
CFLAGS   := $(call smart~get,CFLAGS)
CXXFLAGS := $(call smart~get,CXXFLAGS)
CPPFLAGS := $(call smart~get,CPPFLAGS)
LDFLAGS  := $(call smart~get,LDFLAGS)
LDLIBS   := $(call smart~get,LDLIBS)

USE_MODULES := $(strip \
  $(call smart~get,STATIC_LIBRARIES) \
  $(call smart~get,WHOLE_STATIC_LIBRARIES) \
  $(call smart~get,SHARED_LIBRARIES) \
  )

#$(warning info: $(call smart~get,MODULE), $(USE_MODULES))

EXPORT.CFLAGS   := $(call smart~get~export,CFLAGS)
EXPORT.CXXFLAGS := $(call smart~get~export,CXXFLAGS)
EXPORT.CPPFLAGS := $(call smart~get~export,CPPFLAGS)
EXPORT.LDFLAGS  := $(call smart~get~export,LDFLAGS)
EXPORT.LDLIBS   := $(call smart~get~export,LDLIBS)
EXPORT.INCLUDES := $(call smart~get~export,C_INCLUDES)
