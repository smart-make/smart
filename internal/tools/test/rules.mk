#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

ifndef smart.test.assert
  $(error "smart.test.assert" not defined)
endif

$(call smart.test.assert,smart.test.declared,true)

smart.test.names += $(SRCDIR)

$(info $(SRCDIR))

module-$(SM.MK): $(SM.MK) ; echo $(SRCDIR)
modules: $(SM.MK)
