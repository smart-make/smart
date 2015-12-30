#
#    Copyright (C) 2012-2015, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
$(smart.internal)

#$(warning info: $(NAME), $(TOOL), $(SRCDIR), $(SOURCES))

ifndef TOOL
  #$(warning no TOOL for building $(NAME))
endif #!TOOL

ifndef SRCDIR
  $(error SRCDIR is undefined)
endif #!SRCDIR

modules: module-$(SCRIPT)
clean: clean-$(SCRIPT)

PHONY += module-$(SCRIPT)
PHONY += clean-$(SCRIPT)
module-$(SCRIPT):
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

$(warning $(NAME): $(TOOL), $(PROGRAM), $(SRCDIR))

ifdef TOOL
  include $(smart.root)/internal/tools/$(TOOL)/rules.mk
endif #TOOL

ifdef TARGETS
  include $(smart.root)/internal/targets.mk
  ifdef TARGETS
    module-$(SCRIPT): $(TARGETS)
  endif #TARGETS
endif #TARGETS

ifdef SETTLE
  include $(smart.root)/internal/settle.mk
  settle: settle-$(SCRIPT)
  PHONY += settle-$(SCRIPT)
endif #SETTLE

ifeq ($(SETTLE_ROOT),true)
  $(info settle_root: $(SRCDIR))
  smart.settle_root := $(SRCDIR)
endif #SETTLE_ROOT
