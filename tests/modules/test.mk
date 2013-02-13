#
#    Copyright (C) 2012,2013, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(call smart.test.assert.value,TEST_MODULES_NAME,modules)
$(call smart.test.assert.value,TEST_MODULE_1_NAME,module-1)
$(call smart.test.assert.value,TEST_MODULE_2_NAME,module-2)
$(call smart.test.assert.value,TEST_MODULE_3_NAME,module-3)
$(call smart.test.assert.value,TEST_MODULE_1_SMMK,./module-1.mk)
$(call smart.test.assert.value,TEST_MODULE_2_SMMK,./module-2.mk)
$(call smart.test.assert.value,TEST_MODULE_3_SMMK,./module-3.mk)
$(foreach 1,\
    ./smart \
    ./module-1.mk \
    ./module-2.mk \
    ./module-3.mk \
    , $(call smart.test.assert.equal,$(filter $1,$(smart.list)),$1))
