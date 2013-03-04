#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifndef SOURCES
  SOURCES := $(call smart.find,$(SRCDIR),%.c %.cpp %.cc)
endif #SOURCES

SOURCES.c := $(filter %.c,$(SOURCES))
SOURCES.cc := $(filter %.cc,$(SOURCES))
SOURCES.c++ := $(filter %.cpp,$(SOURCES))

## Build it as a new app.
include $(smart.tooldir)/glue/app.mk
