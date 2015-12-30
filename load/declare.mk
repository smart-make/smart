#
#    Copyright (C) 2012-2015, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
$(smart.internal)

SCRIPT := $(lastword $(MAKEFILE_LIST))
SRCDIR := $(smart.me)
NAME := $(patsubst %.mk,%,$(notdir $(SCRIPT)))
ifeq ($(NAME),smart)
  NAME := $(notdir $(SRCDIR))
endif
ifeq ($(NAME),.)
  NAME := $(notdir $(or $(CURDIR),$(PWD)))
endif

#$(warning $(CURDIR), $(PWD))
#$(warning $(NAME), $(TOOL), $(SCRIPT))

## Append 'x' to the LEVEL.x list.
LEVEL.x := $(strip $(LEVEL.x) x)
MAKEFILE_LIST.$(LEVEL.x) := $(MAKEFILE_LIST)

$(warning $(NAME): TOOL=$(TOOL), $(LEVEL.x))

#TOOL :=

TOOL_CONFIG := $(wildcard $(SRCDIR)/.tool)
-include $(TOOL_CONFIG)
ifndef TOOL
  $(foreach 1,$(wildcard $(smart.root)/internal/tools/*/detect.mk),$(eval include $1))
endif #!TOOL

## Search tool config (.tool) upwards
ifeq ($(or $(TOOL),$(TOOL_CONFIG)),)
  TOOL_CONFIG := $(call smart.findtool,$(SRCDIR))
  ifndef TOOL_CONFIG
    TOOL_CONFIG := $(shell $(smart.root)/scripts/find-tool-config $(SRCDIR))
  endif
  -include $(TOOL_CONFIG)
endif #no TOOL nor TOOL_CONFIG

ifdef TOOL
  ifeq ($(TOOL),names)
    $(error "names" is invalid TOOL)
  else
    include $(smart.tooldir)/context.mk
  endif
endif

#$(warning $(smart.context.names))
#$(warning $(NAME), $(TOOL), $(TOOL_CONFIG), $(SCRIPT))

MAKEFILE_LIST := $(MAKEFILE_LIST.$(LEVEL.x))
MAKEFILE_LIST.$(LEVEL.x) :=

## Clear context variables.
$(foreach 1,$(filter-out NAME CURDIR SCRIPT SRCDIR \
	TOOL TOOL_CONFIG LEVEL LEVEL.x,\
	$(filter $(smart.context.names),$(.VARIABLES))),\
    $(eval $1 :=))

#$(warning $(NAME), $(TOOL), $(SRCDIR), $(SCRIPT))

## Do tool specific declaraction.
include $(smart.root)/internal/declare.mk
