MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

ifndef SRCDIR
  smart~error := SRCDIR is undefined
  $(error $(smart~error))
endif

ifdef SUBDIRS
  include $(smart.root)/internal/subdirs.mk
endif #SUBDIRS

ifdef SOURCES
  include $(smart.root)/internal/sources.mk
endif #SOURCES

ifdef PROGRAMS
  include $(smart.root)/internal/programs.mk
endif #PROGRAMS

ifdef LIBRARIES
  include $(smart.root)/internal/libraries.mk
endif #LIBRARIES

clean: clean-$(SM.MK)
$(eval clean-$(SM.MK): ; \
  rm -vf $(strip $(LIBRARIES) $(PROGRAMS) $(OBJECTS)))
