#
#    Copyright (C) 2012-2015, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
#------------------------------------------------------------
#
$(smart.internal)
$(foreach @script,$(SCRIPT),$(eval include $(smart.root)/funs/smart.save))

ifndef TOOL
  $(warning $(NAME): TOOL)
  $(info $(SCRIPT):1: TOOL must be set, e.g. 'TOOL = gcc')
  $(error TOOL is undefined)
endif #!TOOL

ifndef SRCDIR
  $(warning $(NAME): SRCDIR)
  $(info $(SCRIPT):1: SRCDIR should not be changed)
  $(error SRCDIR is undefined)
endif #!SRCDIR

ifdef SUBDIRS
  include $(smart.root)/tool/subdirs.mk
endif #SUBDIRS

ifdef MODULES
  include $(smart.root)/tool/modules.mk
endif #MODULES

-include $(smart.tooldir)/pend.mk

#$(warning $(NAME): $(LEVEL.x))

## Remove the last 'x' from the LEVEL.x list.
LEVEL.x := $(wordlist 2,$(words $(LEVEL.x)),x $(LEVEL.x))
