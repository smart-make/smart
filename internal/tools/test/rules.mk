#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

ifndef smart.test.assert.value
  $(error "smart.test.assert.value" not defined)
endif #smart.test.assert.value
ifndef smart.test.assert.equal
  $(error "smart.test.assert.equal" not defined)
endif #smart.test.assert.equal

$(call smart.test.assert.value,smart.test.declared,true)

smart.test.names += $(SRCDIR)

include $(SRCDIR)/check-$(NAME).mk
#$(call smart.test.assert.value,TEST_FOO,foo-$(NAME))
#$(call smart.test.assert.value,TEST_BAR,bar-$(NAME))

ifndef smart.list
  $(error "smart.list" undefined)
else
  include test.mk
endif #smart.list

$(eval module-$(SCRIPT): $(SCRIPT) ; @echo "$(SMART.MK)")
modules: module-$(SCRIPT)
