#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
smart.me = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
smart.root := $(smart.me)
smart.stack :=

smart.context.names := SM.MK \
  NAME SRCDIR \
  SUBDIRS SOURCES PROGRAMS LIBRARIES \
  CFLAGS CXXFLAGS

SMART.DECLARE := $(smart.root)/declare.mk
SMART.RULES := $(smart.root)/rules.mk

MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

ROOT := $(smart.me)
ROOT.MK := $(wildcard $(ROOT)/sm.mk)

smart~error :=

#
#  @param: smart~fun
#  
define smart~defun
$(eval \
ifdef smart~fun
define $(smart~fun)
$$(eval \
   smart~error :=
   include $(smart.root)/funs/$(smart~fun)
   ifneq ($$(smart~error),)
     $$$$(error $(smart~fun): $$(smart~error))
   endif
  )
endef
endif
 )
endef #smart~defun

$(foreach smart~fun,\
    $(notdir $(filter-out %~,$(wildcard $(smart.root)/funs/smart.*))),\
    $(smart~defun))

.SUFFIXES:

smart~defun :=

ifdef ROOT.MK
  include $(ROOT.MK)
endif #ROOT.MK

.DEFAULT_GOAL := modules
