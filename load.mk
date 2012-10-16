#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
smart.me = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
smart.root := $(smart.me)
smart.stack :=
smart.list :=
smart.export :=

smart.context.names := SM.MK NAME SRCDIR \
  SUBDIRS SOURCES PROGRAMS LIBRARIES REQUIRES \
  CFLAGS CXXFLAGS ARFLAGS LDFLAGS LOADLIBS LIBADD \
  DEFINES INCLUDES

define smart.internal
$(eval MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
endef #smart.internal

SMART.MK = $(SM.MK)
SMART.DECLARE := $(smart.root)/declare.mk
SMART.RULES := $(smart.root)/pend.mk

$(smart.internal)
ROOT := $(smart.me)

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

smart~defun :=

.SUFFIXES:

PHONY := modules clean
ROOT.MK := $(wildcard $(ROOT)/sm.mk)
ifdef ROOT.MK
  include $(ROOT.MK)
else
  ROOT.MK := $(wildcard $(ROOT)/smart.mk)
  ifdef ROOT.MK
    MAKEFILE_LIST += $(ROOT.MK)
    include $(SMART.DECLARE)
    include $(ROOT.MK)
    include $(SMART.RULES)
  endif #ROOT.MK
endif #ROOT.MK

#$(warning info: $(smart.list))

define smart~rules
$(eval \
  $(foreach @name,$(smart~sm),$(smart.restore))
  include $(smart.root)/rules.mk
 )
endef #smart~rules

$(foreach smart~sm,$(smart.list),$(smart~rules))

smart~rules :=

.DEFAULT_GOAL := modules
