#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

#$(warning info: $(NAME), $(SRCDIR), $(SM.MK))

ifndef SRCDIR
  smart~error := SRCDIR is undefined
  $(error $(smart~error))
endif #!SRCDIR

module-$(SM.MK):

ifdef REQUIRES
  $(foreach @name, $(REQUIRES),\
    $(eval include $(smart.root)/funs/smart.require)\
    $(foreach smart~sm, $(smart.scripts.$(@name)),\
      $(eval module-$(SM.MK): module-$(smart~sm))\
     ))

  #$(info $(NAME): $(REQUIRES))
endif #REQUIRES

OBJECTS :=

ifdef TOOL
  include $(smart.root)/internal/tools/$(TOOL)/rules.mk
endif #TOOL

ifdef SETTLE
  include $(smart.root)/internal/settle.mk
  settle: settle-$(SM.MK)
  PHONY += settle-$(SM.MK)
endif #SETTLE

ifeq ($(SETTLE_ROOT),true)
  $(info settle_root: $(SRCDIR))
  smart.settle_root := $(SRCDIR)
endif #SETTLE_ROOT

$(eval clean-$(SM.MK):; $(if $(LIBRARY)$(PROGRAM)$(OBJECTS),@rm -vf $(strip $(LIBRARY) $(PROGRAM) $(OBJECTS))))
clean: clean-$(SM.MK)

PHONY += module-$(SM.MK) clean-$(SM.MK)
