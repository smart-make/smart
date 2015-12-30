#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
$(smart.internal)

$(warning $(NAME): $(TOOL), $(PROGRAM), $(SOURCES))

ifdef SOURCES
  include $(smart.tooldir)/sources.mk
  ifdef OBJECTS
    clean-$(SCRIPT): smart~clean~files += $(OBJECTS)
  endif #OBJECTS
endif #SOURCES

smart~LDLIBS := $(LDLIBS)
ifdef FULLLIBS
  smart~LDLIBS += -Wl,--whole-archive $(sort $(FULLLIBS))
  smart~LDLIBS += -Wl,--no-whole-archive $(LOADLIBS) $(LIBADD)
else
  smart~LDLIBS += $(LOADLIBS) $(LIBADD)
endif #FULLLIBS

ifdef LIBRARY
  include $(smart.tooldir)/libraries.mk
  ifdef LIBRARY
    clean-$(SCRIPT): smart~clean~files += $(LIBRARY)
    module-$(SCRIPT): $(LIBRARY)
    modules: module-$(SCRIPT)
  endif #LIBRARY
endif #LIBRARY

ifdef PROGRAM
  include $(smart.tooldir)/programs.mk
  ifdef PROGRAM
    clean-$(SCRIPT): smart~clean~files += $(PROGRAM)
    module-$(SCRIPT): $(PROGRAM)
    modules: module-$(SCRIPT)
  endif #PROGRAM
endif #PROGRAM
