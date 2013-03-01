#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

SM.MK := $(lastword $(MAKEFILE_LIST))
SRCDIR := $(smart.me)
NAME := $(patsubst %.mk,%,$(notdir $(SM.MK)))
ifeq ($(NAME),smart)
  NAME := $(notdir $(SRCDIR))
endif
ifeq ($(NAME),.)
  NAME := $(notdir $(PWD))
endif
#$(warning $(NAME), $(SRCDIR), $(SM.MK))

MAKEFILE_LIST.saved := $(MAKEFILE_LIST)
TOOL :=

-include $(SRCDIR)/.tool
ifndef TOOL
  $(foreach 1,$(wildcard $(smart.root)/internal/tools/*/detect.mk),$(eval include $1))
endif #TOOL

#$(warning $(SRCDIR), $(TOOL))
#$(warning $(lastword $(MAKEFILE_LIST)))

ifdef TOOL
  ifeq ($(TOOL),names)
    $(error "names" is invalid TOOL)
  else
    include $(smart.tooldir)/context.mk
  endif
endif

#$(warning $(smart.context.names))
#$(warning $(NAME), $(TOOL), $(SRCDIR), $(SM.MK))

MAKEFILE_LIST := $(MAKEFILE_LIST.saved)
MAKEFILE_LIST.saved :=

$(foreach 1,$(filter-out SM.MK SRCDIR NAME TOOL,$(filter $(smart.context.names),$(.VARIABLES))),$(eval $1 :=))
#$(warning $(NAME), $(TOOL), $(SRCDIR), $(SM.MK))

include $(smart.root)/internal/declare.mk
