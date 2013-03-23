#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

#$(warning info: $(NAME), $(SRCDIR), $(SCRIPT))

ifndef SRCDIR
  smart~error := SRCDIR is undefined
  $(error $(smart~error))
endif #!SRCDIR

module-$(SCRIPT):
clean-$(SCRIPT): smart~clean~files :=

ifdef REQUIRES
  $(foreach @name, $(REQUIRES),\
    $(eval include $(smart.root)/funs/smart.require)\
    $(foreach smart~sm, $(smart.scripts.$(@name)),\
      $(eval module-$(SCRIPT): module-$(smart~sm))\
     ))

  #$(info $(NAME): $(REQUIRES))
endif #REQUIRES

OBJECTS :=

ifdef TOOL
  include $(smart.root)/internal/tools/$(TOOL)/rules.mk
endif #TOOL

ifdef TARGETS
  include $(smart.root)/internal/targets.mk
  ifdef TARGETS
    module-$(SCRIPT): $(TARGETS)
    modules: module-$(SCRIPT)
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

clean: clean-$(SCRIPT)
clean-$(SCRIPT): ; @rm -vf $(smart~clean~files)

PHONY += module-$(SCRIPT) clean-$(SCRIPT)
