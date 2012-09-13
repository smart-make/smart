#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
smart.me = $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
smart.root := $(smart.me)

SMART.DECLARE := $(smart.root)/declare.mk
SMART.RULES := $(smart.root)/rules.mk

MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

#ROOT := $(PWD)
ROOT := $(smart.me)
ROOT.mk := $(wildcard $(ROOT)/sm.mk)

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

ifdef ROOT.mk
  include $(ROOT.mk)
endif #ROOT.mk

.DEFAULT_GOAL := modules
