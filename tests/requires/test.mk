#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(call smart.test.assert.value,TEST_MODULES_NAME,requires)
$(foreach 1,\
    ./smart \
    , $(call smart.test.assert.equal,$(filter $1,$(smart.list)),$1))
