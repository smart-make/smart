#
#    Copyright (C) 2012, 2013, by Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

export GOPATH := $(PWD)/$(GOPATH:$(ROOT)/%=%)

ifdef PACKAGES
  include $(smart.tooldir)/packages.mk
endif #PACKAGES

ifdef COMMANDS
  include $(smart.tooldir)/commands.mk
endif #COMMANDS

modules: module-$(SCRIPT)
