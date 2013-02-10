#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

TOOL :=
MAKEFILE_LIST.saved := $(MAKEFILE_LIST)
$(foreach 1,$(wildcard $(smart.root)/internal/tools/*/detect.mk),$(eval include $1))
MAKEFILE_LIST := $(MAKEFILE_LIST.saved)
MAKEFILE_LIST.saved :=
TOOL.saved := $(TOOL)

$(foreach 1,$(filter $(smart.context.names),$(.VARIABLES)),$(eval $1 :=))

TOOL := $(TOOL.saved)
ifdef TOOL
  include $(smart.root)/internal/declare.mk
else
  $(error TOOL undefined for "$(smart.me)")
endif
