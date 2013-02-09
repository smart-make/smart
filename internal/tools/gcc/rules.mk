#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

ifdef SOURCES
  include $(smart.root)/internal/tools/gcc/sources.mk
endif #SOURCES

ifdef FULLLIBS
  LDLIBS  = -Wl,--whole-archive $(sort $(FULLLIBS))
  LDLIBS += -Wl,--no-whole-archive $(LOADLIBS) $(LIBADD)
else
  LDLIBS  = $(LOADLIBS) $(LIBADD)
endif #FULLLIBS

ifdef PROGRAM
  include $(smart.root)/internal/tools/gcc/programs.mk
  ifdef PROGRAM
    module-$(SM.MK): $(PROGRAM)
    modules: module-$(SM.MK)
  endif #PROGRAM
endif #PROGRAM

ifdef LIBRARY
  include $(smart.root)/internal/tools/gcc/libraries.mk
  ifdef LIBRARY
    module-$(SM.MK): $(LIBRARY)
    modules: module-$(SM.MK)
  endif #LIBRARY
endif #LIBRARY

ifdef TARGETS
  include $(smart.root)/internal/tools/gcc/targets.mk
  ifdef TARGETS
    module-$(SM.MK): $(TARGETS)
    modules: module-$(SM.MK)
  endif #TARGETS
endif #TARGETS
