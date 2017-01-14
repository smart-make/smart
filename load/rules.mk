#
#    Copyright (C) 2012-2015, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
$(smart.internal)

ifndef TOOL
  $(warning $(NAME): TOOL)
  $(info $(SCRIPT):1: TOOL is empty)
  $(error TOOL is undefined)
endif #!TOOL

ifndef SRCDIR
  $(warning $(NAME): SRCDIR)
  $(info $(SCRIPT):1: SRCDIR is empty)
  $(error SRCDIR is undefined)
endif #!SRCDIR

PHONY += module-$(SCRIPT)
PHONY += clean-$(SCRIPT)

modules: module-$(SCRIPT)
module-$(SCRIPT):

clean: clean-$(SCRIPT)
clean-$(SCRIPT): smart~clean~files :=
clean-$(SCRIPT):
	@$(if $(smart~clean~files),rm -vf $(smart~clean~files),true)

ifdef REQUIRES
  ## Compute the import names base on the current module's $(TOOL).
  smart~import~names := $(filter-out $(smart.context.names.private) \
    EXPORT.% export.% THIS.% this.%, $(smart.context.names))

  ##
  ## Import variables from EXPORT.* defined in $(@script) recursively
  ##   @name	the name of requiree
  ##   @script  the script of requiree
  define smart~require
  $(foreach @var,$(smart~import~names),$(eval \
    ifdef smart.context.EXPORT.$(@var)-$(@script)
      $(@var) += $(smart.context.EXPORT.$(@var)-$(@script))
    endif
    ifdef smart.context.export.$(@var)-$(@script)
      $(@var) += $(smart.context.export.$(@var)-$(@script))
    endif
   ))\
  $(foreach @script,$(smart.scripts.$(@name)),\
    $(foreach @name, $(smart.context.REQUIRES-$(@script)),\
      $(call smart~require)))
  endef #smart~require

  ##
  ## Each SCRIPT defines only one module, but many scripts may
  ## define the same module. So $(smart.scripts.$(@name)) might
  ## be a list of such scripts.
  $(foreach @name, $(REQUIRES),\
    $(foreach @script,$(smart.scripts.$(@name)),$(call smart~require)\
      $(no-info module-$(SCRIPT): $(@name) -> module-$(@script))\
      $(eval module-$(SCRIPT): module-$(@script))\
     ))

  #$(info $(NAME): $(REQUIRES))

  smart~import~names :=
endif #REQUIRES

OBJECTS :=

$(warning $(NAME): $(TOOL), $(SRCDIR))

include $(smart.tooldir)/rules.mk

ifdef TARGETS
  include $(smart.root)/tool/targets.mk
  ifdef TARGETS
    module-$(SCRIPT): $(TARGETS)
  endif #TARGETS
endif #TARGETS

ifdef SETTLE
  include $(smart.root)/tool/settle.mk
  settle: settle-$(SCRIPT)
  PHONY += settle-$(SCRIPT)
endif #SETTLE

ifeq ($(SETTLE_ROOT),true)
  $(warning $(NAME): settle_root: $(SRCDIR))
  smart.settle_root := $(SRCDIR)
endif #SETTLE_ROOT
