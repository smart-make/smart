#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

TOOL :=
MAKEFILE_LIST.saved := $(MAKEFILE_LIST)
$(foreach 1,$(wildcard $(smart.root)/internal/tools/*/detect.mk),$(eval include $1))

ifdef TOOL
  ifeq ($(TOOL),names)
    $(error "names" is invalid TOOL)
  else
    include $(smart.tooldir)/context.mk
  endif
else
  $(error TOOL undefined for "$(smart.me)")
endif

MAKEFILE_LIST := $(MAKEFILE_LIST.saved)
MAKEFILE_LIST.saved :=
TOOL.saved := $(TOOL)

$(foreach 1,$(filter $(smart.context.names),$(.VARIABLES)),$(eval $1 :=))

ifdef TOOL.saved
  TOOL := $(TOOL.saved)
  include $(smart.root)/internal/declare.mk
endif
