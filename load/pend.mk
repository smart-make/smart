#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)
$(foreach @script,$(SCRIPT),$(eval include $(smart.root)/funs/smart.save))

ifndef TOOL
  #$(warning no TOOL for building $(NAME))
endif #!TOOL

ifndef SRCDIR
  $(error SRCDIR is undefined)
endif #!SRCDIR

ifdef SUBDIRS
  include $(smart.root)/internal/subdirs.mk
endif #SUBDIRS

ifdef MODULES
  include $(smart.root)/internal/modules.mk
endif #MODULES

-include $(smart.tooldir)/pend.mk
