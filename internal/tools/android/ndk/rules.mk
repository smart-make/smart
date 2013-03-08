#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

## Setup toolchain version, and default to 4.6..
NDK_TOOLCHAIN_VERSION := $(or $(TOOLCHAIN_VERSION),4.6)

## Prepare sources..
ifndef SOURCES
  SOURCES := $(call smart.find,$(SRCDIR),%.c %.C %.cpp %.cc %.CC)
endif #SOURCES

## Build it as a new app..
include $(smart.tooldir)/glue/app.mk
