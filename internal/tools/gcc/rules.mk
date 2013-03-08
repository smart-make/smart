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

ifdef LIBRARY
  include $(smart.tooldir)/libraries.mk
  ifdef LIBRARY
    module-$(SCRIPT): $(LIBRARY)
    modules: module-$(SCRIPT)
  endif #LIBRARY
endif #LIBRARY

ifdef PROGRAM
  include $(smart.tooldir)/programs.mk
  ifdef PROGRAM
    module-$(SCRIPT): $(PROGRAM)
    modules: module-$(SCRIPT)
  endif #PROGRAM
endif #PROGRAM
