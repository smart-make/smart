#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME): $(TOOL), $(SOURCES))
#$(warning $(NAME): $(TOOL), $(PROGRAM))

ifdef SOURCES
  include $(smart.tooldir)/sources.mk
endif #SOURCES

ifdef FULLLIBS
  LDLIBS  = -Wl,--whole-archive $(sort $(FULLLIBS))
  LDLIBS += -Wl,--no-whole-archive $(LOADLIBS) $(LIBADD)
else
  LDLIBS  = $(LOADLIBS) $(LIBADD)
endif #FULLLIBS

ifdef PROGRAM
  include $(smart.tooldir)/programs.mk
  ifdef PROGRAM
    module-$(SM.MK): $(PROGRAM)
    modules: module-$(SM.MK)
  endif #PROGRAM
endif #PROGRAM

ifdef LIBRARY
  include $(smart.tooldir)/libraries.mk
  ifdef LIBRARY
    module-$(SM.MK): $(LIBRARY)
    modules: module-$(SM.MK)
  endif #LIBRARY
endif #LIBRARY
