#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)
$(foreach @name,$(SM.MK),$(eval include $(smart.root)/funs/smart.save))

ifndef SRCDIR
  smart~error := SRCDIR is undefined
  $(error $(smart~error))
endif #!SRCDIR

ifdef SUBDIRS
  include $(smart.root)/internal/subdirs.mk
endif #SUBDIRS

ifdef MODULES
  include $(smart.root)/internal/modules.mk
endif #MODULES
