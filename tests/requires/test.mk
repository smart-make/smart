#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(call smart.test.assert.value,TEST_REQUIRES_NAME,requires)
$(foreach 1,\
    ./smart \
    ./tree/smart \
    ./module-5.mk \
    ./module-1.mk \
    ./tree/leaf-1/smart \
    ./module-3.mk \
    ./module-2.mk \
    ./tree/leaf-2/smart \
    ./tree/leaf-3/smart \
    ./module-4.mk \
    ./tree/leaf-4/smart \
    ./tree/leaf-5/smart \
    , $(call smart.test.assert.equal,$(filter $1,$(smart.list)),$1))
