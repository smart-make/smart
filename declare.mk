#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)
$(foreach smart~name,$(smart.context.names),$(eval $(smart~name):=))
$(foreach smart~name,$(smart.context.names:%=EXPORT.%),$(eval $(smart~name):=))

SETTLE_ROOT :=

SM.MK := $(lastword $(MAKEFILE_LIST))
SRCDIR := $(smart.me)
NAME := $(notdir $(SRCDIR))

ifeq ($(NAME),.)
  NAME := $(notdir $(PWD))
endif

CC := gcc
CXXFLAGS :=
ARFLAGS := cru
LDFLAGS :=
LIBADD :=
LOADLIBS := 

ifeq ($(shell uname),Linux)

else # uname == Linux
LOADLIBS += \
  -lkernel32\
  -luser32\
  -lgdi32\
  -lcomdlg32\
  -lwinspool\
  -lwinmm\
  -lshell32\
  -lcomctl32\
  -lole32\
  -loleaut32\
  -luuid\
  -lrpcrt4\
  -ladvapi32\
  -lwsock32\
  -lodbc32\
  -lws2_32\
  -lnetapi32\
  -lmpr\

endif # uname != Linux

EXEEXT := .exe

-include $(wildcard $(ROOT)/declare.mk)
