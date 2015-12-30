#
#    Copyright (C) 2012-2015, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
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

##
## Note this is a "=" variable, some names are determined by TOOL specific
## context. A TOOL can define it's own context names using:
##     * smart.context.global.<tool-name> := ...
##     * smart.context.private.<tool-name> := ...
##     * smart.context.<tool-name> := ...
##
## Names appears in each list has special meanings:
##     * smart.context.global.*
##       Defines context names "global" to all modules using <tool-name>.
##     * smart.context.private.*
##       Defines context names "private" to the module, EXPORT.* is not
##       performed on these names.
##     * smart.context.*
##       Defines regular context names, which can be exported using
##       EXPORT.* or export.* grammar.
##       
smart.context.names.global = $(smart.context.global.$(TOOL))
smart.context.names.private = NAME SCRIPT TOOL TOOL_FILE SRCDIR SUBDIRS \
  REQUIRES MODULES TARGETS SETTLE_ROOT SETTLE \
  $(smart.context.private.$(TOOL))
smart.context.names = this.% export.% THIS.% EXPORT.% \
  $(smart.context.names.private) $(smart.context.$(TOOL))

## Internal Declaration
define smart.internal
$(eval MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
endef #smart.internal

## Set module context variable.
## e.g. $(call smart.set,$(NAME),VAR,value)
define smart.set
$(foreach script,$(smart.scripts.$(strip $1)),$(eval smart.context.$(strip $2)-$(script) := $(strip $3)))
endef #smart.set

## Get module context variable.
## e.g. $(call smart.get,$(NAME),VAR)
define smart.get
$(foreach script,$(smart.scripts.$(strip $1)),$(smart.context.$(strip $2)-$(script)))
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
TOP := $(PWD)

smart~error :=

#
#  Define funs.
#  
$(eval include $(smart.root)/funs/defun)
ifneq ($(call smart.test,a,b,c),a-b-c)
  $(error smart: defun errors)
endif

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

## Context is bound to each script.
$(foreach @script,$(smart.list),$(call smart.restore)\
    $(eval include $(smart.root)/rules.mk))

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
