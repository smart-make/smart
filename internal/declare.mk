#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

SM.MK := $(lastword $(MAKEFILE_LIST))
SRCDIR := $(smart.me)
NAME := $(notdir $(SRCDIR))
ifeq ($(NAME),.)
  NAME := $(notdir $(PWD))
endif

-include $(wildcard $(smart.tooldir)/declare.mk)
-include $(wildcard $(ROOT)/declare.mk)
