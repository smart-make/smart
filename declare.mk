#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

MAKEFILE_LIST.saved := $(MAKEFILE_LIST)
SRCDIR := $(smart.me)
TOOL :=

-include $(SRCDIR)/.tool
ifndef TOOL
  -include $(ROOT)/.tool
endif #TOOL
ifndef TOOL
  $(foreach 1,$(wildcard $(smart.root)/internal/tools/*/detect.mk),$(eval include $1))
endif #TOOL

ifdef TOOL
  ifeq ($(TOOL),names)
    $(error "names" is invalid TOOL)
  else
    include $(smart.tooldir)/context.mk
  endif
else
  $(error "TOOL" undefined for "$(SRCDIR)")
endif

MAKEFILE_LIST := $(MAKEFILE_LIST.saved)
MAKEFILE_LIST.saved :=
TOOL.saved := $(TOOL)

$(foreach 1,$(filter $(smart.context.names),$(.VARIABLES)),$(eval $1 :=))

ifdef TOOL.saved
  TOOL := $(TOOL.saved)
  include $(smart.root)/internal/declare.mk
endif
