#
#    Copyright (C) 2012-2015, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
$(smart.internal)

## Append 'x' to the LEVEL.x list.
LEVEL.x := $(strip $(LEVEL.x) x)

SCRIPT := $(lastword $(MAKEFILE_LIST))
SRCDIR := $(smart.me)
NAME := $(patsubst %.mk,%,$(notdir $(SCRIPT)))

## NAME correction.
ifeq ($(NAME),smart)
  NAME := $(notdir $(SRCDIR))
endif
ifeq ($(NAME),.)
  NAME := $(notdir $(or $(CURDIR),$(PWD)))
endif

## Checking TOOL.
ifndef TOOL
  $(warning $(NAME): TOOL)
  $(info $(SCRIPT):1: TOOL must be defined (e.g. config.mk?))
  $(error TOOL is undefined)
endif
ifeq ($(TOOL),names)
  $(warning $(NAME): TOOL)
  $(info $(SCRIPT):1: '$(TOOL)' is invalid tool)
  $(error TOOL is invalid)
endif
ifeq ($(wildcard $(smart.tooldir)/context.mk),)
  $(warning $(NAME): TOOL)
  $(info $(SCRIPT):1: '$(TOOL)' is unknown tool)
  $(error TOOL is invalid)
endif

#$(warning $(NAME): TOOL=$(TOOL), $(LEVEL))

## Setup tool context.
MAKEFILE_LIST.$(LEVEL.x) := $(MAKEFILE_LIST)
include $(smart.tooldir)/context.mk
MAKEFILE_LIST := $(MAKEFILE_LIST.$(LEVEL.x))
MAKEFILE_LIST.$(LEVEL.x) :=

#$(warning $(smart.context.names))

## Clear context variables.
$(foreach 1,$(filter-out TOOL NAME CURDIR SCRIPT SRCDIR LEVEL LEVEL.x,\
	$(filter $(smart.context.names),$(.VARIABLES))),\
    $(eval $1 :=))

## Do tool specific declaraction.
include $(smart.root)/tool/declare.mk
