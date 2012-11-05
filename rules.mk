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

ifdef SOURCES
  include $(smart.root)/internal/sources.mk
endif #SOURCES

ifdef FULLLIBS
  LDLIBS  = -Wl,--whole-archive $(sort $(FULLLIBS))
  LDLIBS += -Wl,--no-whole-archive $(LOADLIBS) $(LIBADD)
else
  LDLIBS  = $(LOADLIBS) $(LIBADD)
endif #FULLLIBS

ifdef PROGRAM
  include $(smart.root)/internal/programs.mk
  module-$(SM.MK): $(PROGRAM)
  modules: module-$(SM.MK)
endif #PROGRAM

ifdef LIBRARY
  include $(smart.root)/internal/libraries.mk
  module-$(SM.MK): $(LIBRARY)
  modules: module-$(SM.MK)
endif #LIBRARY

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
