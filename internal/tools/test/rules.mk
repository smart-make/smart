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

$(info test: $(SRCDIR))
$(call smart.test.assert.value,smart.test.declared,true)
$(call smart.test.assert.value,TEST_FOO,foo-$(NAME))
$(call smart.test.assert.value,TEST_BAR,bar-$(NAME))

smart.test.names += $(SRCDIR)

ifndef smart.list
  $(error "smart.list" undefined)
endif #smart.list

$(foreach 1,\
    ./smart \
    ./leaf-1/smart \
    ./leaf-1/leaf-1-1/smart \
    ./leaf-1/leaf-1-1/leaf-1-1-1/smart \
    ./leaf-1/leaf-1-1/leaf-1-1-2/smart \
    ./leaf-1/leaf-1-1/leaf-1-1-3/smart \
    ./leaf-1/leaf-1-2/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-1/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/leaf-1-2-2-1/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/leaf-1-2-2-2/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-2/leaf-1-2-2-3/smart \
    ./leaf-1/leaf-1-2/leaf-1-2-3/smart \
    ./leaf-1/leaf-1-3/smart \
    ./leaf-2/smart \
    ./leaf-2/leaf-2-1/smart \
    ./leaf-2/leaf-2-2/smart \
    ./leaf-2/leaf-2-3/smart \
    ./leaf-3/smart \
    ./leaf-3/leaf-3-1/smart \
    ./leaf-3/leaf-3-2/smart \
    ./leaf-3/leaf-3-3/smart \
    , $(call smart.test.assert.equal,$(filter $1,$(smart.list)),$1))

module-$(SM.MK): $(SM.MK) ; echo $(SRCDIR)
modules: $(SM.MK)
