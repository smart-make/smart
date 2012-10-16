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

#ifdef SUBDIRS
#  include $(smart.root)/internal/subdirs.mk
#endif #SUBDIRS

ifdef REQUIRES
 $(foreach @name,$(REQUIRES),$(smart.require))
endif #REQUIRES

ifdef SOURCES
  include $(smart.root)/internal/sources.mk
endif #SOURCES

ifdef PROGRAMS
  include $(smart.root)/internal/programs.mk
  module-$(SM.MK): $(PROGRAMS)
  modules: module-$(SM.MK)
endif #PROGRAMS

ifdef LIBRARIES
  include $(smart.root)/internal/libraries.mk
  module-$(SM.MK): $(LIBRARIES)
  modules: module-$(SM.MK)
endif #LIBRARIES

$(eval clean-$(SM.MK):; $(if $(LIBRARIES)$(PROGRAMS)$(OBJECTS),rm -vf $(strip $(LIBRARIES) $(PROGRAMS) $(OBJECTS))))
clean: clean-$(SM.MK)

PHONY += module-$(SM.MK) clean-$(SM.MK)
