#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
ifneq ($(words $(MAKEFILE_LIST)),1)
  $(error You should always run smart utility!)
endif

#SHELL := /bin/bash

smart.tooldir = $(smart.root)/internal/tools/$(TOOL)
smart.stack :=
smart.list :=
smart.export :=
smart.settle_root :=
smart.context.names = this.% export.% THIS.% EXPORT.% \
  SCRIPT TOOL TOOL_FILE NAME SRCDIR REQUIRES SUBDIRS MODULES TARGETS \
  SETTLE_ROOT SETTLE $(smart.context.$(TOOL))

define smart.internal
$(eval MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
endef #smart.internal

## Set module context variable.
## e.g. $(call smart.set,$(NAME),VAR,value)
define smart.set
$(eval smart.context.$(strip $2)-$(smart.scripts.$(strip $1)) := $(strip $3))
endef #smart.set

## Get module context variable.
## e.g. $(call smart.get,$(NAME),VAR)
define smart.get
$(smart.context.$(strip $2)-$(smart.scripts.$(strip $1)))
endef #smart.get

smart.test.load.before.push :=
smart.test.load.before.pop :=
smart.test.load.after.push :=
smart.test.load.after.pop :=
smart.test.loaded :=

## Assert variable value
define smart.test.assert.value
$(eval \
  ifndef $1
    $$(error undefined "$1")
  else
    ifneq ("$($(strip $1))","$2")
      $$(error bad value "$(strip $1)", ("$($1)" != "$2"))
    endif
  endif
 )
endef #smart.test.assert.value

## Assert equal
define smart.test.assert.equal
$(eval \
  ifneq ($1,$2)
    $$(error ($1 != $2))
  endif
 )
endef #smart.test.assert.equal

SM.MK = $(error SM.MK is replaced by SCRIPT)
SMART.MK = $(SCRIPT)
SMART.DECLARE := $(smart.root)/declare.mk
SMART.RULES := $(smart.root)/pend.mk

$(smart.internal)
ROOT := $(or $(smart.me),.)
OUT = $(ROOT)/out

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
   smart~result :=
   include $(smart.root)/funs/$(smart~fun)
   ifneq ($$(smart~error),)
     $$$$(error $(smart~fun): $$(smart~error))
   endif
  )$$(smart~result)
endef
endif
 )
endef #smart~defun

$(foreach smart~fun,\
    $(notdir $(filter-out %~,$(wildcard $(smart.root)/funs/smart.*))),\
    $(smart~defun))

smart~defun :=
smart~fun :=

.SUFFIXES:

define smart~sync~smart~e
$(if $(and $1,$(wildcard $1.e)),$(if $(wildcard $1),\
 $(info $(shell $(smart.root)/scripts/sync-smart-e -save $1))\
 $(if $(shell ls $1.e),,$(error failed to save "$1"))\
 ,\
 $(info $(shell $(smart.root)/scripts/sync-smart-e -restore $1))\
 $(if $(shell ls $1),,$(error failed to prepare "$1"))))
endef #smart~sync~smart~e

PHONY := modules settle clean
ROOT.MK := $(wildcard $(ROOT)/sm.mk)
ifdef ROOT.MK
  include $(ROOT.MK)
else
  $(call smart~sync~smart~e,$(ROOT)/smart)
  ROOT.MK := $(strip $(or \
    $(or $(wildcard $(ROOT)/smart),$(shell ls $(ROOT)/smart)),\
    $(or $(wildcard $(ROOT)/smart.mk),$(shell ls $(ROOT)/smart.mk))))
  ifdef ROOT.MK
    MAKEFILE_LIST += $(ROOT.MK)
    include $(SMART.DECLARE)
    include $(ROOT.MK)
    include $(SMART.RULES)
  endif #ROOT.MK
endif #ROOT.MK

#$(warning info: $(smart.list))

define smart~unique
$(eval \
  ifdef $1
    smart~unique.v := $($1)
    $1 :=
    $$(foreach _,$$(smart~unique.v),$$(if $$(filter $$_,$$($1)),,$$(eval $1 += $$_)))
    $1 := $$(strip $$($1))
    smart~unique.v :=
  endif
 )
endef #smart~unique

define smart~rules
$(smart.restore)$(eval \
  include $(smart.root)/rules.mk
 )
endef #smart~rules

$(foreach @script,$(smart.list),$(smart~rules))

smart~rules :=

.DEFAULT_GOAL := modules

###############################
# TODO: using these to replace smart.context
foo:  FOO = foo
foo1: FOO += foo1
foo2: FOO += foo2

FOOBAR = $(warning $@)
foo: ~ = $(FOOBAR)

foo:  foo1 ; @echo $@: $(FOO)$~
foo1: foo2 ; @echo $@: $(FOO)
foo2:	   ; @echo $@: $(FOO)
