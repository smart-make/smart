#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

ifndef smart.test.assert
  $(error "smart.test.assert" not defined)
endif #smart.test.assert

$(info test: $(SRCDIR))
$(call smart.test.assert,smart.test.declared,true)
$(call smart.test.assert,TEST_FOO,foo-$(NAME))
$(call smart.test.assert,TEST_BAR,bar-$(NAME))

smart.test.names += $(SRCDIR)

module-$(SM.MK): $(SM.MK) ; echo $(SRCDIR)
modules: $(SM.MK)
